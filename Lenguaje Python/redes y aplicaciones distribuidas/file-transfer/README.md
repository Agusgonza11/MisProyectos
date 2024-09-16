# File Transfer

Aplicación de red de arquitectura cliente-servidor que implementa la funcionalidad de transferencia de archivos mediante las operaciones _UPLOAD_ (de un cliente hacia el servidor) y _DOWNLOAD_ (del servidor hacia el cliente), usando los protocolos Stop-and-Wait y Selective Repeat.

### Requerimientos

- Python 3.6 o superior
- Bibliotecas:
  - socket
  - argparse
  - pytest
  - logging
  - zlib
  - struct

## Uso

### Servidor

Para iniciar el servidor, ejecutar el siguiente comando:

```bash
python3 start-server.py [-h] [-v | -q] [-H ADDR] [-p PORT] [-s DIRPATH] [-pr PROTOCOL]
```
Opcionales:

`-h`, `--help`: información sobre la ejecución del comando y salida.

`-v`, `--verbose`: configura la _verbosidad_ del output de modo que se muestren logs de información, debug y error.

`-q`, `--quiet`: configura la _verbosidad_ del output de modo que solo se muestren logs de error.

`-H`, `--host`: dirección IP del servidor. Default: 'localhost'

`-p`, `--port`: puerto del servidor. Default: '8080'

`-s`, `--storage`: path de almacenamiento en el servidor. Default: 'storage/'

`-pr`, `--protocol`: protocolo de transferencia de archivos. Default: 'SW'

Ejemplo: 
``` bash
python3 start-server.py -q -H localhost -p 4000 -s storage/
```

### Cliente

#### Upload

Para iniciar el cliente y realizar una subida, ejecutar el siguiente comando:

```bash
python3 upload.py [-h] [-v | -q] [-H ADDR] [-p PORT] [-s FILEPATH] [-n FILENAME] [-pr PROTOCOL]
```
Opcionales:

`-h`, `--help`: información sobre la ejecución del comando y salida.

`-v`, `--verbose`: configura la _verbosidad_ del output de modo que se muestren logs de información, debug y error.

`-q`, `--quiet`: configura la _verbosidad_ del output de modo que solo se muestren logs de error.

`-H`, `--host`: dirección IP del servidor. Default: 'localhost'

`-p`, `--port`: puerto del servidor. Default: '8080'

`-s`, `--source`: path del archivo a subir. Default: '/'   

`-n`, `--name`: nombre del archivo a subir. Default: el nombre del archivo en el origen.

`-pr`, `--protocol`: protocolo de transferencia de archivos. Default: 'SW'

Ejemplo:
``` bash
python3 upload.py invoice_to_upload.pdf -q -H localhost -p 4000 -s files -n invoice.pdf -pr SW
```

#### Download

Para iniciar el cliente y realizar una descarga, ejecutar el siguiente comando:

```bash
python3 download.py [-h] [-v | -q] [-H ADDR] [-p PORT] [-d FILEPATH] [-n FILENAME] [-pr PROTOCOL]
```

Opcionales:

`-h`, `--help`: información sobre la ejecución del comando y salida.

`-v`, `--verbose`: configura la _verbosidad_ del output de modo que se muestren logs de información, debug y error.

`-q`, `--quiet`: configura la _verbosidad_ del output de modo que solo se muestren logs de error.

`-H`, `--host`: dirección IP del servidor. Default: 'localhost'

`-p`, `--port`: puerto del servidor. Default: '8080'

`-d`, `--dst`: path del archivo en el destino. Default: '/'

`-n`, `--name`: nombre del archivo a subir. Default: el nombre del archivo en el servidor.

`-pr`, `--protocol`: protocolo de transferencia de archivos. Default: 'SW' 

Ejemplo:
```bash
python3 download.py sendables/file.txt -H localhost -p 8080 -s downloads/ -n d_file.txt 
```

