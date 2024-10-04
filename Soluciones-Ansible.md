# Solución Reto 2 - Actividad 1

---
## Introducción

A continuación encontrarás una guía detallada que te permitirá entender como resolver cada uno de los puntos del primer reto de la hackathon, usando Ansible en cada uno de los puntos. En las proximas sesiones se mostrará cada uno de los puntos, y se propondrá un playbook que funcionará exclusivamente para resolver dicho reto, esto con la intención de explorar en individual cada uno de los desafíos presentados. En la última sección se presentará un playbook general con el cual se pueden resolver todos los retos propuestos en este documento.

Para solucionar los ejercicios, se usará la colección `ansible.builtin` incluido en las collecciones que se instalan por defecto cuando se instala Ansible. Para listar los módulos disponibles, puedes consultar el listado en este enlace [Ansible builtin](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/index.html).

---
## 1. Actualización

**Ennunciado:** Garantizar que el sistema operativo de todos los servidores se encuentre completamente actualizado (no deben tener actualizaciones pendientes).

Para completar esta tarea es necesario actualizar los paquetes del sistema operativo, por lo que en la colección de `ansible.builtin`, se debe buscar el módulo `package`. Puedes encontrar la documentación del módulo package en este enlace: [Ansible builtin package](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/package_module.html). 

```yml
# Garantizar que el sistema operativo se encuentre completamente actualizado 
- name: Ejercicio 1 - Que el SO se encuentre completamente actualizado
  hosts: all
  tasks:
    - name: Todos los paquetes se encuentran actualizados
      ansible.builtin.package:
        name: "*"
        state: latest
```

Hay 2 parámetros obligatorios la usar este módulo:

- `name`: Especifica el nombre del paquete o Especificador del paquete con versión. En este playbook se usa el `*`, para indicar que se debe realizar esta operación sobre todos los paquetes del sistema. 
- `state`: Si se debe instalar (`present`) o eliminar (`absent`) un paquete. Puedes utilizar otros estados como `latest` SOLAMENTE si son compatibles con los módulos del paquete subyacente ejecutados. En este caso se usa dicho estado para indicarle al módulo que debe actualizar todos los paquetes.

---
## 2. Ultima versión de los paquetes especificados

**Ennunciado:** Cada servidor debe tener instalado la última versión de los paquetes:
- samba
- samba-client

Para completar esta tarea es necesario acudir al módulo `package`. Puedes encontrar la documentación del módulo package en este enlace: [Ansible builtin package](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/package_module.html). 

```yml
# Ejercicio 2 - Debe tener instalado la última versión de los paquetes
#   samba
#   samba-client
- name: Ejercicio 2 - Debe tener instaladas ultimas versiones de paquetes
  hosts: all
  tasks:
    - name: Asegurar que las ultimas versiones esten instaladas
      ansible.builtin.package:
        name:
          - samba
          - samba-client
        # Debe ser latest y no present
        state: latest
```

A diferencia de lo visto en el punto anterior, en este caso se especifica una lista de elementos sobre los cuales se va a actuar bajo el parámetro `name`:

- samba
- saba-client

---
## 3. Activar el servicio de SELinux

**Ennunciado:** Cada servidor debe tener el servicio de **SELinux activo** de forma permanente.



---
## 4. Detener el servicio `cups`

**Ennunciado:** En cada servidor deben garantizar que el servicio llamado `cups` **NO** se encuentre activo y además no inicie después del reinicio del mismo.

Ya que en este caso se debe configurar en servicio, acudiremos al módulo [service](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/service_module.html#ansible-collections-ansible-builtin-service-module), que se encuentra disponible dentro de la colección `ansible.builtin`:

```yml
# Garantice que el servicio llamado cups no se encuentre activo y que no 
# inicie después del reinicio de la máquina.
- name: Ejercicio 4 - Configurar cups
  hosts: all
  tasks:
    - name: cups no se encuentra activo ni inicia luego del reinicio
      ansible.builtin.service:
        name: cups
        enable: false
        state: stopped
```

Para este ejercicio se usaron los siguientes parámetros del módulo `service`:

- `name`: Nombre del servicio (Parámetro requerido).
- `enable`: Indica el estado en el que debe estar el servicio al reiniciar la máquina (Parámetro de tipo booleano)
- `state`: `started`/`stopped` son acciones idempotentes que no ejecutarán comandos a menos que sea necesario. En este caso se usa el parámetro `stopped` para detener la ejecución del servicio `cups`.

---
## 5. Creación de usuarios

**Ennunciado:** En cada servidor deben crear cinco (5) usuarios adicionales con sus respectivas contraseñas seguras asignadas, asegurando que dichas credenciales expiren cada 3 meses (90 días), que los usuarios deban esperar al menos 10 días para poder hacer un cambio de password, y que se les notifique con 7 días de anticipación al venimiento de su password, que el mismo va a expirar. Los usuarios creados deben relacionarse con el grupo `hackatonLabs`, en caso de que el grupo no exista, deben crearlo.
   
| Usuario | Password | Grupo |
| --- | --- | --- |
| compras | DefaultHackatonLabs123* | hackatonLabs |
| comercial | DefaultHackatonLabs123* | hackatonLabs |
| ventas | DefaultHackatonLabs123* | hackatonLabs |
| administrativo | DefaultHackatonLabs123* | hackatonLabs |
| soporte | DefaultHackatonLabs123* | hackatonLabs |

Para este problema se deben usar 2 módulos diferentes, en primer lugar el módulo `group`, con el cual se gestionan los grupos, y por el otro el módulo `user`, con el cual se gestionan los usuarios.

Primero que nada se usará el módulo [group](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/group_module.html#ansible-collections-ansible-builtin-group-module), con el cual se validará inicialmente si el grupo `hackatonLabs` existe. Si existe por el principio de la idempotencia no pasará nada. En caso de que no exista se creará el grupo nuevo. Los parámetros empleados para resolver esta parte del reto son los siguientes:

- `name`: Nombre del grupo a gestionar (Parámetro oligatorio).
- `state`: Indica si el grupo debe estar presente o ausente en el servidor. Por defecto se setea en `present`.

En los ejemplos de la documentación del módulo `group`, podrás encontrar un ejemplo de como crear un grupo.

```yml
# Ejercicio 5 - Debe crear cinco (5) usuarios adicionales con sus respectivas 
# contraseñas seguras asignadas, estos usuarios deben pertenecer al grupo
# adicional hackatonLabs
- name: Ejercicio 5 - Creación de usuarios
  hosts: all
  become: true
  tasks:
    - name: Crear grupo hackatonLabs
      ansible.builtin.group:
        name: hackatonLabs
        state: present

    - name: Crear usuarios
      ansible.builtin.user:
        name: "{{ item }}"
        groups: hackatonLabs
        append: true
        password: "{{ 'DefaultHackatonLabs123*' | password_hash('sha512', 'secretsalt') }}"
        # Restricciones de seguridad en las credenciales
        password_expire_max: 90
        password_expire_min: 10
        password_expire_warn: 7
        state: present
      # with_items es aceptable acá
      loop:
        - compras
        - comercial
        - ventas
        - administrativo
        - soporte
```

Por otro lado, para completar la gestión de los usuarios, se usa el módulo [user](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html#ansible-collections-ansible-builtin-user-module), en el cual se usan los siguientes parámetros:

- `name`: Nombre del usuario que se va a crear, borrar o modificar.
- `groups`: Sirve para setear una lista de grupos a los que puede pertenecer el usuario que se va a gestionar.
- `append`: Parámetro de tipo booleano. Si es `true`, agrega el usuario a los grupos especificados en el parámetro `groups`. Si es `false`, el usuario solo se agregará a los grupos especificados en el parámetro `groups` y se lo eliminará de todos los demás grupos a los que pertenezca.
- `password`: Si se proporciona, configura la contraseña del usuario con el hash cifrado proporcionado (en Linux). Adicionalmente en este parámetro se seteo el modificador `password_hash('sha512', 'secretsalt')`, con el cual se cifrará el password indicado en texto plano (`DefaultHackatonLabs123*`).
- `password_expire_max`: Número máximo de días entre cambios de password.
- `password_expire_min`: Número mínimo de días entre cambios de password.
- `password_expire_warn`: Número de días de anticipación con los que se dará advertencia por el vencimiento del password vigente.
- `state`: Si la cuenta debe existir o no, tomar medidas si el estado es diferente al declarado.

Finalmente para indicar los usuarios que se van a crear, se usa un bucle, el cual se define con la variable `{{ item }}`, empleada en el parámetro `name`, y con la lista ordenada bajo la estructura `loop`, en la cual se indican los nombres de los usuarios que se van a crear:

```yml
      loop:
        - compras
        - comercial
        - ventas
        - administrativo
        - soporte
```

---
## 6. Creación de archivos

**Ennunciado:** En cada servidor deben crear una carpeta llamada `/guias` que pertenezca al grupo `hackatonLabs` y además los usuarios que pertenezcan a este grupo puedan leer, escribir, ejecutar sobre dicha carpeta. Esta carpeta se debe poblar con 100 archivos de texto vacíos con el nombre: `archivo-1.txt`, `archivo-2.txt`... `archivo-100.txt`.

Para resolver este ejercicio, utilizaremos el módulo [files](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html#ansible-collections-ansible-builtin-file-module), que nos permite modificar archivos y las propiedades de los archivos. En la primera tarea se usa este módulo, con los siguientes parámetros, para crear la carpeta `guias`, y configurar los permisos solicitados.

- `path`: Ruta del archivo que va a ser manejado (Parámetro requerido).
- `group`: Nombre del grupo l que debe pertenecer el objeto del sistema de archivos.
- `mode`: Los permisos que debe tener el objeto del sistema de archivos resultante. El formato que se usa en este caso es el sistema Octal, en el que cada digito del número indica en orden los permisos para `owner`, `owner_group`, `other_users`. Los niveles de acceso se configuran sumando los valores que representan cada uno de los permisos:
  - `Lectura`: 4
  - `Escritura`: 2
  - `Ejecución`: 1
  - Ejemplo: Si se quieren conceder permisos de lectura (4), escritura (2) y ejecución (1) al owner del archivo, permisos de lectura (4) y escritura (2) al grupo al que pertenece el owner del archivo, y permisos solo de lectura (4) para los demás usuarios, la representación en Octal de dicho ejemplo sería la siguiente: `764`
  - En lo solicitado en el ejemplo, se especifican los permisos para el `owner` y el `owner_group` (Lectura, escritura y ejecución (4+2+1=7)), pero no es especifica nada para los otros usuarios, por lo que en este caso se puede colocar cualquier valor, en este caso, se setean los permisos en 0, es decir, los otros usuarios no pueden leer los archivos, modificarlos, ni ejecutarlos.
- `state`: Las acciones que se ejecutan por medio de este parámetro son muy variadas, por lo que los invitamos a leer la documentación para entender que se ejecuta con las opciones listadas a continuación. En este ajercicio se usó la opción `directory`, que al utilizarse creará todos los subdirectorios intermedios si no existen.
  - `absent`
  - `directory`
  - `file`
  - `hard`
  - `link`
  - `touch`

```yml
# Debe crear una carpeta llamada guias que pertenezca al grupo hackatonLabs y que los
# usuarios que pertenezcan a este grupo puedan leer, escribir, ejecutar sobre 
# esta carpeta.
- name: Ejercicio 6 - Crear carpeta y archivos
  hosts: all
  tasks:
      # Crear la carpeta guias
      - name: Crear carpeta guias
        ansible.builtin.file:
          path: guias
          group: hackatonLabs
          mode: "770"
          state: directory

      # Crear 100 archivos con una estructura determinada
      - name: Crea 100 archivos en el directorio guias
        ansible.builtin.command:
          cmd: touch guias/archivo-{{ item }}.txt
        with_sequence: start=1 end=100
```

Aunque se podría seguir usando el módulo file para crear los 100 archivos, para la parte final, y para mostrar una forma alternativa de resolver este ejercicio, se usa el módulo [command](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command_module.html#ansible-collections-ansible-builtin-command-module), este módulo se usa para ejecutar comandos simples en máquinas Linux, para hacer lo mismo en Windows, es posible usa el módulo [ansible.windows.win_command](https://docs.ansible.com/ansible/latest/collections/ansible/windows/win_command_module.html#ansible-collections-ansible-windows-win-command-module). Con respecto a este módulo debe tener en cuenta lo siguiente:

- El comando dado se ejecutará en todos los nodos seleccionados
- Los comandos **NO** se procesarán a través del shell, por lo que las variables como `$HOSTNAME` y las operaciones como "*", "<", ">", "|", ";" y "&" no funcionarán. Utilice el módulo [ansible.builtin.shell](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/shell_module.html#ansible-collections-ansible-builtin-shell-module) si necesita estas funciones.
- Para crear tareas de comando que sean más fáciles de leer que las que utilizan argumentos delimitados por espacios, pase parámetros utilizando la palabra clave de tarea `args` o utilice el parámetro `cmd`.

Para resolver este ejercicio se usó el parámetro `cmd`, que se usa para especificar el comando a correr, en este caso `touch guias/archivo-{{ item }}.txt`, y finalmente para iterar, se usa el comando `with_sequence`. El comando `with_sequence` en Ansible se utiliza para iterar sobre una secuencia de números o letras en un bucle dentro de una tarea, permitiéndote realizar acciones repetitivas, en este caso iterar de 1 a 100, para lo cual se usa la variable `{{ item }}`, dentro de la estructura del comando `touch guias/archivo-{{ item }}.txt`.

---
## 7. Copiar archivos

**Ennunciado:** En cada servidor creen una subcarpeta llamada `/guias/config` y copien en esta ubicación los archivos `/etc/redhat-release`, `/etc/passwd` y `/usr/share/dict/linux.words`.

---
## 8.

**Ennunciado:** En cada servidor almacenen la versión exacta del sistema operativo en el archivo `/tmp/os-version.txt`.

---
## 9.

**Ennunciado:** En cada servidor creen un enlace simbólico llamado `/guias/config/grupos` apuntando al archivo `/etc/group`.

---
## 10.

**Ennunciado:** En cada servidor incluyan el mensaje **"El problema no es problema"** en el archivo `/etc/motd`, para que cuando un usuario haga login se muestra el MOTD (mensaje del dia).

---
## 11.

**Ennunciado:** En cada servidor listen las particiones y los puntos de montaje del sistema operativo y envíen la salida al archivo `/tmp/particiones.txt`.

---
## 12.

**Ennunciado:** Cada servidor debe tener un total de 25 GB de almacenamiento utilizable **(Servidor BD ya tiene montado el disco)**.
