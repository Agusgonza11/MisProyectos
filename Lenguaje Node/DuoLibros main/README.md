# DuoLibros

Este proyecto está compuesto por un backend y un frontend que trabajan juntos para ofrecer una experiencia completa. A continuación, encontrarás las instrucciones para ejecutar ambas partes de manera independiente.

---

## Ejecución del Backend

1. **Pararte en el directorio**
    ```bash
    cd backend/
    ```

2. **Instalar dependencias**:  
   ```bash
   npm install
   ```

3. **Setup Base de Datos**
    ```bash
    npm run psql-up

    npx prisma migrate dev
    ```

4. **Cargar los seeders**
    ```bash
    npm run seed
    ```

5. **Correr el backend**
    ```bash
    npm run start
    ```

## Ejecución del Frontend

1. **Pararte en el directorio**
    ```bash
    cd frontend/
    ```

2. **Instalar dependencias**:    
   ```bash
   npm install
   ```

5. **Correr el frontend**
    ```bash
    npm start
    ```

---

### Integrantes (Grupo 6)
- Ciriani Chiara
- Gonzalez Agustín
- Guglielmi Nicolás
- Magnani Elian
- Rueda Nazarena
- Shih Ian

