#define FUSE_USE_VERSION 30

#include <fuse.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/file.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include "fs.c"

disco_t *disco;

static int
fisopfs_getattr(const char *path, struct stat *st)
{
	printf("[debug] fisopfs_getattr(%s)\n", path);

	if (strcmp(path, "/") == 0 || existe_directorio(disco, path) == TRUE) {
		st->st_uid = getuid();
		st->st_gid = getgid();
		st->st_mode = __S_IFDIR | 0755;
		st->st_nlink = 2;
		st->st_mtime = time(NULL);
		st->st_atime = time(NULL);
	} else if (strcmp(path, "/fisop") == 0) {
		st->st_uid = getuid();
		st->st_mode = __S_IFREG | 0644;
		st->st_size = 2048;
		st->st_nlink = 1;
		st->st_mtime = time(NULL);
		st->st_atime = time(NULL);
	} else if (existe_archivo(disco, path) == TRUE) {
		st->st_uid = getuid();
		st->st_gid = getgid();
		st->st_mode = __S_IFREG | 0644;
		st->st_size = 2048;
		st->st_nlink = 1;
		st->st_mtime = time(NULL);
		st->st_atime = time(NULL);
	} else {
		return -ENOENT;
	}
	return EXIT_SUCCESS;
}

static int
fisopfs_readdir(const char *path,
                void *buffer,
                fuse_fill_dir_t filler,
                off_t offset,
                struct fuse_file_info *fi)
{
	// printf("[debug] fisopfs_readdir(%s)", path);
	filler(buffer, ".", NULL, 0);
	filler(buffer, "..", NULL, 0);
	if (strcmp(path, "/") == 0) {
		int iterador_dir = quedarme_mayor(disco->dir_actual,
		                                  disco->cant_directorios);
		for (int i = 0; i < iterador_dir; i++) {
			if (strcmp("", disco->directorios[i]))
				filler(buffer, disco->directorios[i], NULL, 0);
		}
		int iterador_arch =
		        quedarme_mayor(disco->ar_actual, disco->cant_archivos);
		for (int i = 0; i < iterador_arch; i++) {
			if (strcmp("", disco->archivos[i]) &&
			    !strcmp(path, disco->tabla_arch_dir[i]))
				filler(buffer, disco->archivos[i], NULL, 0);
		}
	} else if (existe_directorio(disco, path) == TRUE) {
		int iterador_arch =
		        quedarme_mayor(disco->ar_actual, disco->cant_archivos);
		for (int i = 0; i < iterador_arch; i++) {
			if (!strcmp(path + 1, disco->tabla_arch_dir[i])) {
				filler(buffer, disco->archivos[i], NULL, 0);
			}
		}
	}
	return EXIT_SUCCESS;
}

static int
fisopfs_read(const char *path,
             char *buffer,
             size_t size,
             off_t offset,
             struct fuse_file_info *fi)
{
	printf("[debug] fisopfs_read(%s, %lu, %lu)\n", path, offset, size);
	int contador = 0;
	int nueva_pos = 0;
	for(int i = 0; i < strlen(path); i++){
		if(path[i] == '/'){
			if(contador == 1){
				nueva_pos = i;
			}
			contador++;
		}
	}
	int indice_archivo = obtener_archivo(disco, path + nueva_pos);
	if (indice_archivo == ENOENT)
		return -ENOENT;
	char *contenido = disco->contenidos[indice_archivo];
	if(strlen(contenido) > 0){
		strcat(contenido, "\n");
	}
	if (offset + size > strlen(contenido))
		size = strlen(contenido) - offset;

	size = size > 0 ? size : 0;
	for(int i = 0; i < strlen(contenido); i++){
		if(contenido[i] == '\t')
			contenido[i] = '\n';
	}
	strncpy(buffer, contenido + offset, size);

	return size;
}

static int
fisopfs_mknod(const char *path, mode_t mode, dev_t rdev)
{
	path++;
	return agregar_archivo(disco, path);
}


static int
fisopfs_mkdir(const char *path, mode_t mode)
{
	path++;
	return agregar_directorio(disco, path);
}

static int
fisopfs_write(const char *path,
              const char *buffer,
              size_t size,
              off_t offset,
              struct fuse_file_info *fi)
{
	int contador = 0;
	int nueva_pos = 0;
	for(int i = 0; i < strlen(path); i++){
		if(path[i] == '/'){
			if(contador == 1){
				nueva_pos = i;
			}
			contador++;
		}
	}
	int indice_archivo = obtener_archivo(disco, path + nueva_pos);
	if (indice_archivo == -ENOENT)
		return -ENOENT;
	char nuevo_buffer[TAM_ARCHIVOS_CONT];
	if(offset == 0){
		strcpy(disco->contenidos[indice_archivo], buffer);
		return size;
	}
	strcpy(nuevo_buffer, disco->contenidos[indice_archivo]);
	if(strlen(nuevo_buffer) > 0)
		strcat(nuevo_buffer, "\t");
	strcat(nuevo_buffer, buffer);
	strcpy(disco->contenidos[indice_archivo], nuevo_buffer);
	return size;
}

static int
fisopfs_create(const char *path, mode_t mode, struct fuse_file_info *fi)
{
	int indice_archivo = obtener_archivo(disco, path);
	if (indice_archivo != -ENOENT)
		return -EEXIST;
	path++;
	int resultado = -1;
	for (size_t i = 0; i < strlen(path); i++) {
		if (path[i] == '/') {
			resultado = agregar_archivo_a_directorio(disco, path, i);
			break;
		}
	}
	if (resultado != 0 && resultado != -ENOMEM) {
		resultado = agregar_archivo(disco, path);
	}
	return resultado;
}

static int
fisopfs_utimens(const char *path, const struct timespec tv[2])
{
	// Implementada para que no me tire linea de error el touch (no se puede modificar el timespec)
	return EXIT_SUCCESS;
}

static int
fisopfs_rmdir(const char *path)
{
	return eliminar_directorio(disco, path);
}

static int
fisopfs_unlink(const char *path)
{
	return eliminar_archivo(disco, path);
}

static void
fisopfs_destroy(void *buffer)
{
	guardar_file_system(disco);
}

static int
fisopfs_flush(const char *buffer, struct fuse_file_info *fi)
{
	return guardar_file_system(disco);
}

	/** Change the size of a file */
static int
fisopfs_truncate(const char *path, off_t size){
	return size;
}

static struct fuse_operations operations = {
	.getattr = fisopfs_getattr,
	.readdir = fisopfs_readdir,
	.read = fisopfs_read,
	.mknod = fisopfs_mknod,
	.mkdir = fisopfs_mkdir,
	.write = fisopfs_write,
	.create = fisopfs_create,
	.utimens = fisopfs_utimens,
	.rmdir = fisopfs_rmdir,
	.unlink = fisopfs_unlink,
	.destroy = fisopfs_destroy,
	.flush = fisopfs_flush,
	.truncate = fisopfs_truncate,
};

int
main(int argc, char *argv[])
{
	char nombre_disco[TAM_NOMBRE_ARCH];
	if(argv[3] == NULL){
		strcpy(nombre_disco, "myfs");
	} else {
		strcpy(nombre_disco, argv[3]);
		argv[3] = NULL;
		argc = 3;
	}
	strcat(nombre_disco, ".fisopfs");
	disco = crear_disco(nombre_disco);
	abrir_file_system(disco);
	return fuse_main(argc, argv, &operations, NULL);
	free(disco);
}
