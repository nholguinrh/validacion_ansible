# Solución Reto 1 - Actividad 1

Para ejecutar los pasos descritos a continuación lo primero será realizar las conexiones con los servidores administrados por medio de `ssh`, para lo cual debe usar el siguiente comando:

```bash
ssh TBD
```

Una vez que haya establecido la conexión, podrá proceder a ejecutar cada uno de los pasos descritos a continuación.

## 1. Garantizar que el sistema operativo se encuentre completamente actualizado (no debe tener actualizaciones pendientes).

Para validar el listado de actualizaciones disponibles se debe ejecutar el siguiente comando:

```bash
dnf list updates
```

Si por otro lado solamente se quiere saber la cantidad de dependencias que deben ser actulizadas, se puede ejecutar el siguiente comando:

```
sudo dnf list upgrades | wc -l
```

Y si requiere saber cuantas de esas actualizaciones, corresponden a temas de seguridad, se pueden filtrar utilizando el argumento `--security`

```bash
sudo dnf list upgrades --security | wc -l
```

La actualización de los paquetes se realiza por medio del siguiente comando

```bash
dnf update
```

---
## 2. Debe tener instalado la última versión de los paquetes samba y samba-client

Para verificar si los paquetes mencionados si quiera se encuentran instalados, se debe usar el comando:

```bash
rpm -q samba
rpm -q samba-client
```

Si los paquetes no se encuentran presentes, se deben instalar en el servidor ejecutando el siguiente comando:

```bash
$ rpm -q samba
package samba is not installed
$ sudo dnf install samba
```

Una vez se haya completado la instalación, se puede verificar ejecutando nuevamente el comando `rpm -q samba`, como se muestra a continuación:

```bash
$ rpm -q samba
samba-4.19.4-105.el9_4.x86_64
```

En caso de que los paquetes mencionados se encuentren instalados se pueden actualizar bien sea usando `yum` o `dnf`. En el siguiente ejemplo se usa `dnf`.

```bash
sudo dnf update samba
sudo dnf update samba-client
```

Si el paquete ya se encuentra actualizado se debería apreciar una respuesta como la siguiente:

```bash
$ dnf update samba
Updating Subscription Management repositories.
Last metadata expiration check: 0:05:05 ago on Fri 23 Aug 2024 06:00:27 AM UTC.
Dependencies resolved.
Nothing to do.
Complete!
```

Finalmente para validar la versión de samba, se debe ejecutar el comando `smbd --version`:

```bash
$ smbd --version
Version 4.19.4
```

O también se puede validar por medio del comando `rpm -qi samba`:

```bash
$ rpm -qi samba
rpm -qi samba
Name        : samba
Epoch       : 0
Version     : 4.19.4
Release     : 105.el9_4
Architecture: x86_64
Install Date: Fri 23 Aug 2024 06:02:16 AM UTC
Group       : Unspecified
Size        : 3419192
License     : GPL-3.0-or-later AND LGPL-3.0-or-later
Signature   : RSA/SHA256, Thu 02 May 2024 06:02:24 PM UTC, Key ID 199e2f91fd431d51
Source RPM  : samba-4.19.4-105.el9_4.src.rpm
Build Date  : Wed 01 May 2024 07:04:24 PM UTC
Build Host  : x86-64-01.build.eng.rdu2.redhat.com
Packager    : Red Hat, Inc. <http://bugzilla.redhat.com/bugzilla>
Vendor      : Red Hat, Inc.
URL         : https://www.samba.org
Summary     : Server and Client software to interoperate with Windows machines
Description :
Samba is the standard Windows interoperability suite of programs for Linux and
Unix.
$
$ rpm -qi samba-client
Name        : samba-client
Epoch       : 0
Version     : 4.19.4
Release     : 105.el9_4
Architecture: x86_64
Install Date: Fri 23 Aug 2024 06:09:28 AM UTC
Group       : Unspecified
Size        : 2629204
License     : GPL-3.0-or-later AND LGPL-3.0-or-later
Signature   : RSA/SHA256, Thu 02 May 2024 06:02:23 PM UTC, Key ID 199e2f91fd431d51
Source RPM  : samba-4.19.4-105.el9_4.src.rpm
Build Date  : Wed 01 May 2024 07:04:24 PM UTC
Build Host  : x86-64-01.build.eng.rdu2.redhat.com
Packager    : Red Hat, Inc. <http://bugzilla.redhat.com/bugzilla>
Vendor      : Red Hat, Inc.
URL         : https://www.samba.org
Summary     : Samba client programs
Description :
The samba-client package provides some SMB/CIFS clients to complement
the built-in SMB/CIFS filesystem in Linux. These clients allow access
of SMB/CIFS shares and printing to SMB/CIFS printers.
```

---
## 3. Debe tener el servicio de SELinux Activo de forma permanente

El primer paso consiste en validar el estado de SELinux, para lo cual se pueden usar los siguientes comandos:

```bash
$ sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      33
```

Al usar el comando `sestatus`, debe fijarse en la fila `Current mode`, o de una forma mucho más sencilla puede usar el comando `getenforce`, como se muestra a continuación:

```bash
$ getenforce
Enforcing
```

Para verificar que los cambios se apliquen de forma permanente, debe revisar el contenido del archivo `/etc/selinux/config`, para lo cual puede ejecutar el comando `cat /etc/selinux/config`, como se muestra a continuación:

```bash
$ cat /etc/selinux/config

# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
# See also:
# https://docs.fedoraproject.org/en-US/quick-docs/getting-started-with-selinux/#getting-started-with-selinux-selinux-states-and-modes
#
# NOTE: In earlier Fedora kernel builds, SELINUX=disabled would also
# fully disable SELinux during boot. If you need a system with SELinux
# fully disabled instead of SELinux running with no policy loaded, you
# need to pass selinux=0 to the kernel command line. You can use grubby
# to persistently set the bootloader to boot with selinux=0:
#
#    grubby --update-kernel ALL --args selinux=0
#
# To revert back to SELinux enabled:
#
#    grubby --update-kernel ALL --remove-args selinux
#
SELINUX=permissive
# SELINUXTYPE= can take one of these three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
```

Recuerda que el parámetro SELINUX puede tomar 3 valores:

- **enforcing**: El sistema aplica activamente las políticas de seguridad definidas
- **permissive**: El sistema registra las infracciones mientras aplica las políticas y sin bloquearlas activamente.
- **disabled**: SELinux se encuentra desabilitado y se usa DAC como mecanismo de control de acceso.

En el ejemplo presentado, el estado es `permisive`, por lo que se debe cambiar a `enforcing` para asegurar el sistema. Para hacer el cambio en el archivo se usará `VIM`, de la siguiente forma:

```bash
vim /etc/selinux/config
```

Una vez que haya abierto la interfaz de `VIM`, deben presionar la tecla i para entrar en modo de edición, cambiar el valor del parámetro `SELINUX` de `permisive` a `enforcing`, y finalmente guardar los cambios y salir, para lo cual primero debe presionar la tecla de escape (esc), y acto seguido teclear `:wq` (guardar y salir), o tambien `:x` (guardado inteligente, si no hay cambios solo sale, si hay cambios, sale y cierra vim).

Ahora se deben verificar nuevamente el estado de SELINUX, ejecutando de nuevo el comando `cat /etc/selinux/config`

```bash
cat /etc/selinux/config

# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
# See also:
# https://docs.fedoraproject.org/en-US/quick-docs/getting-started-with-selinux/#getting-started-with-selinux-selinux-states-and-modes
#
# NOTE: In earlier Fedora kernel builds, SELINUX=disabled would also
# fully disable SELinux during boot. If you need a system with SELinux
# fully disabled instead of SELinux running with no policy loaded, you
# need to pass selinux=0 to the kernel command line. You can use grubby
# to persistently set the bootloader to boot with selinux=0:
#
#    grubby --update-kernel ALL --args selinux=0
#
# To revert back to SELinux enabled:
#
#    grubby --update-kernel ALL --remove-args selinux
#
SELINUX=enforcing
# SELINUXTYPE= can take one of these three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
```

---
## 4. Garantice que el servicio llamado `cups` **NO** se encuentre activo y que no inicie después del reinicio de la máquina

Lo primero será detener el servicio en caso de que se encuentre activo, usando el comando `sudo systemctl stop cups`.

```bash
$ sudo systemctl stop cups
Failed to stop cups.service: Unit cups.service not loaded.
```

Luego, deshabilita el servicio para evitar que se inicie automáticamente después de un reinicio:

```bash
$ sudo systemctl disable cups
Removed "/etc/systemd/system/multi-user.target.wants/cups.path".
Removed "/etc/systemd/system/multi-user.target.wants/cups.service".
Removed "/etc/systemd/system/sockets.target.wants/cups.socket".
Removed "/etc/systemd/system/printer.target.wants/cups.service".
```

Asegúrate de que el servicio esté deshabilitado y no se esté ejecutando:

```bash
$ sudo systemctl status cups
○ cups.service - CUPS Scheduler
     Loaded: loaded (/usr/lib/systemd/system/cups.service; disabled; preset: enabled)
    Drop-In: /usr/lib/systemd/system/cups.service.d
             └─server.conf
     Active: inactive (dead)
TriggeredBy: ○ cups.socket
       Docs: man:cupsd(8)

ago 14 20:22:15 hostname systemd[1]: Starting CUPS Scheduler...
ago 14 20:22:15 hostname systemd[1]: Started CUPS Scheduler.
ago 14 20:22:17 hostname cupsd[1103]: REQUEST localhost - - "POST / HTTP/1.1" 200 359 Create-Printer-Subscriptions successful-ok
ago 14 20:22:34 hostname cupsd[1103]: REQUEST localhost - - "POST / HTTP/1.1" 200 364 Create-Printer-Subscriptions successful-ok
ago 14 21:20:55 hostname cupsd[1103]: REQUEST localhost - - "POST / HTTP/1.1" 200 187 Renew-Subscription successful-ok
ago 23 01:13:34 hostname cupsd[1103]: REQUEST localhost - - "POST / HTTP/1.1" 200 187 Renew-Subscription client-error-not-found
ago 23 01:33:50 hostname systemd[1]: Stopping CUPS Scheduler...
ago 23 01:33:50 hostname systemd[1]: cups.service: Deactivated successfully.
ago 23 01:33:50 hostname systemd[1]: Stopped CUPS Scheduler.
```

Fijate que en la selida se indique que el servicio se encuentra inactivo `Active: inactive (dead)`.

---
## 5. Creación de usuarios

En cada servidor deben crear cinco (5) usuarios adicionales con sus respectivas contraseñas seguras asignadas, asegurando que dichas credenciales expiren cada 3 meses (90 días), que los usuarios deban esperar al menos 10 días para poder hacer un cambio de password, y que se les notifique con 7 días de anticipación al venimiento de su password, que el mismo va a expirar. Los usuarios creados deben relacionarse con el grupo `hackatonLabs`, en caso de que el grupo no exista, deben crearlo.
   
| Usuario | Password | Grupo |
| --- | --- | --- |
| compras | DefaultHackatonLabs123* | hackatonLabs |
| comercial | DefaultHackatonLabs123* | hackatonLabs |
| ventas | DefaultHackatonLabs123* | hackatonLabs |
| administrativo | DefaultHackatonLabs123* | hackatonLabs |
| soporte | DefaultHackatonLabs123* | hackatonLabs |

Lo primero que se debe hacer, es revisar si el grupo se encuentra creado, para lo cual debe revisar que el grupo se encuentre definido en el archivo `/etc/group`, como se muestra a continuación:

```bash
cat /etc/group | grep hackatonLabs
```

Si este comando no arroja ninguna salida, es debido a que el grupo no existe, por lo que se debe crear el grupo usando el comando `groupadd`, como se muestra a continuación:

```bash
groupadd hackatonLabs
```

Ahora se debe proceder a revisar nuevamente el archivo `/etc/group`, para validar que el grupo se haya creado, y en este caso debería tener una salida como la que se presenta a contianuación:

```bash
$ cat /etc/group | grep hackatonLabs
hackatonLabs:x:1013:
```

Si quieres aprender más acerca de como crear grupos en entornos Linux, te invitamos a leer este articulo: [Añadir un nuevo grupo desde la línea de comandos](https://docs.redhat.com/es/documentation/red_hat_enterprise_linux/8/html/configuring_basic_system_settings/adding-a-new-group-from-the-command-line_managing-users-from-the-command-line).

Ahora que se ha creado el grupo `hackatonLabs` se creará cada uno de los usuarios, para lo cual se debe usar el comando `useradd` o bien el comando `adduser` (hacen lo mismo), tal como se ilustra a continuación:

```bash
sudo useradd -m -G hackatonLabs compras
```

- Opción `-m`: Crea el directorio de inicio del usuario.
- Opción `-G`: Especifica el grupo al que el usuario debe pertenecer.
- Argumento `hackatonLabs`: Especifica el nombre del grupo al que pertenecerá el usuario que se está creando.
- Argumento `compras`: Especifica el nombre del usuario que se está creando.

Para generar los demás usuarios, bastará con repetir el mismo comando otras 4 veces:

```bash
$ sudo useradd -m -G hackatonLabs comercial
$ sudo useradd -m -G hackatonLabs ventas
$ sudo useradd -m -G hackatonLabs administrativo
$ sudo useradd -m -G hackatonLabs soporte
```

Para verificar que los usuarios se han creado correctamente basta con usar el comando `id` y como argumento se debe usar el nombre del usuario que se quiere validar, tal como se muestra en el siguiente ejemplo:

```bash
$ id compras
uid=1012(compras) gid=1014(compras) groups=1014(compras),1013(hackatonLabs)
```

Por otro lado, si quieres consultar todos los usuarios al mismo tiempo bastará con consultar el archivo `/etc/shadow`:

```bash
cat /etc/shadow
root:!*::0:99999:7:::
bin:*:18849:0:99999:7:::
daemon:*:18849:0:99999:7:::
...
...
compras:!!:19994:0:19994:7:::
comercial:!!:19994:0:99999:7:::
ventas:!!:19994:0:99999:7:::
administrativo:!!:19994:0:99999:7:::
soporte:!!:19994:0:99999:7:::
```

Te invitamos a leer el artículo [Managing Users via Command-Line Tools](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/deployment_guide/s2-users-cl-tools#s2-users-cl-tools), si quieres aprender más acerca de la creación de usuarios en Linux.

Ahora que se han creado los usuarios lo siguiente será asignarles contraseñas seguras a cada uno de ellos. Para esto se usará el comando `passwd` usando como argumento el nombre del usuario al cual se le va a asignar una contraseña segura:

```bash
$ sudo passwd compras
Changing password for user compras.
New password: 
Retype new password: 
passwd: all authentication tokens updated successfully.
```

Nota como al ejecutar este comando, el sistema te preguntará por el password que quieres asignar al usuario, y luego de ingresar la contraseña, te solicitará validarla nuevamente antes de aplicar los cambios. Conforme al enunciado del ejercicio, no olvides ingresar en ambas ocasiones la contraseña: `DefaultHackatonLabs123*`. Este procedimiento se repetirá para los 4 usuarios restantes:

```bash
$ sudo passwd comercial
$ sudo passwd ventas
$ sudo passwd administrativo
$ sudo passwd soporte
```

Para validar que los password se hayan asignado correctamente se debe validar el archivo `/etc/passwd`, para lo cual podremos usar el comando `cat`, o cómo se muestra en este caso con el comando tail, para obtener unicamente las últimas líneas del archivo:

```bash
$ tail -5 /etc/passwd
compras:x:1012:1014::/home/compras:/bin/bash
comercial:x:1013:1015::/home/comercial:/bin/bash
ventas:x:1014:1016::/home/ventas:/bin/bash
administrativo:x:1015:1017::/home/administrativo:/bin/bash
soporte:x:1016:1018::/home/soporte:/bin/bash
```

Si quieres aprender más acerca del comando `passwd`, te invitamos a leer el artículo: [Managing Linux users with the passwd command](https://www.redhat.com/sysadmin/managing-users-passwd).

Finalmente se asignarán las políticas de gestión de las credenciales de los usuarios, para lo cual se usará el comando `chage`:

```bash
sudo chage -M 90 -W 7 -m 10 compras
```

- Opción `-M`: Se usa para indicar el número máximo de días que van a transcurrir antes de que sea obligatorio cambias el password.
- Opción `-W`: Se usa para inidcar el número de días con el que se le notificará al usuario que su passwrod va a expirar.
- Opción `-m`: Se usa para indicar la cantidad mínima de días que van a transcurrir antes de que el usuario pueda cambiar su password.

Para verificar que las politicas se hayan implementado correctamente ejecutaremos el comando `sudo chage -l compras`, donde se debe obtener una respuesta similar a la que se observa a continuación:

```bash
$ sudo chage -l compras
Last password change                                    : Sep 28, 2024
Password expires                                        : Dec 27, 2024
Password inactive                                       : never
Account expires                                         : never
Minimum number of days between password change          : 10
Maximum number of days between password change          : 90
Number of days of warning before password expires       : 7
```

En las últimas 3 líneas se puede verificar el periodo mínimo de días antes de poder hacer el cambio de password, el tiempo máximo antes de que el password expire, y la antelación con la que se notificará al usuario del vencimiento de su password.

Ahora solamente resta repetir esste mismo procedimiento para los demás usuarios:

```bash
$ sudo chage -M 90 -W 7 -m 10 comercial
$ sudo chage -M 90 -W 7 -m 10 ventas
$ sudo chage -M 90 -W 7 -m 10 administrativo
$ sudo chage -M 90 -W 7 -m 10 soporte
```

Si quieres aprender más acerca del comando `chage`, te invitamos a leer este artículo: [Forcing Linux system password changes with the chage command](https://www.redhat.com/sysadmin/password-changes-chage-command).


---
## 6. Creación de directorios y archivos

En cada servidor deben crear una carpeta llamada `/guias` dentro del directorio del usuario `soporte` que pertenezca al grupo `hackatonLabs` y además los usuarios que pertenezcan a este grupo puedan leer, escribir, ejecutar sobre dicha carpeta. Esta carpeta se debe poblar con 100 archivos de texto vacíos con el nombre: `archivo-1.txt`, `archivo-2.txt`... `archivo-100.txt`.

Lo priemero que deberías hacer es cambiar al usuario `soporte`.

```bash
su soporte
```

Y ahora debes moverte al directorio raíz del usuario soporte usando el comando `cd`:

```bash
cd ~
```

Para realizar la creación del direcotrio indicado, bastará con usar el comando `mkdir`, con el argumento `guias`:

```bash
mkdir guias
```

Para validar que el directorio se creó exitosamente, y validar la propiedad del mismo puedes usar el comando `ls -la`

```bash
$ ls -la
total 20
drwx------.  3 soporte soporte   96 Sep 28 16:17 .
drwxr-xr-x. 15 root    root    4096 Sep 28 16:06 ..
-rw-------.  1 soporte soporte   16 Sep 28 16:17 .bash_history
-rw-r--r--.  1 soporte soporte   18 Feb 15  2024 .bash_logout
-rw-r--r--.  1 soporte soporte  141 Feb 15  2024 .bash_profile
-rw-r--r--.  1 soporte soporte  492 Feb 15  2024 .bashrc
drwxr-xr-x.  2 soporte soporte    6 Sep 28 16:17 guias
```

Como se puede apreciar en la última línea de la salida del comando `ls -la`, el directorio creado le pertenece al usuario `soporte`, quien a su vez tiene permisos de lectura, escritura y ejecución. Por otro lado el grupo `hackatonLabs` al que pertenece el usuario, solamente tiene permisos de lectura y ejecución, por lo que a partir de este momento procederemos a cambiar dichos permisos.

Para cambiar los permisos de un usuario sobre un directorio se usa el comando `chmod`:

```bash
chmod 775 guias
```

Recuarda que los permisos se asignan en el siguiente orden:

1. Usuario que creé el archivo (**Owner**).
2. Grupo al que pertenece el usuario que creó el archivo (**Group**).
3. Usuarios por fuera del grupo del usuario ue creo el archivo (**Others**).

En este caso se realizó la asignación de cada uno de los permisos de forma numérica, para lo cual debes tener en cuenta lo siguiente:

- Lectura (read (r)) tiene un valor de 4
- Escritura (write (w)) tiene un valor de 2
- Ejecución (execute (x)) tiene un valor de 1

Dependiendo de los permisos que se quieran otorgar, se deben sumar dichos valores. Por ejemplo, si se requieren solamente permisos de lectura, se debe usar el número **4**, si se requieren permisos de lectura y de escritura se debe usar el valor **6**, correspondiente a 4 + 2, o puesto de otra forma lectura + escritura. En el enunciado del ejercicio sa indica que tanto el usuario dueño del directorio `soporte`, como el grupo al que pertenece dicho usuario `hackatonLabs`, deben tener permisos de lectura, escritura y ejecución, por lo tanto `4 + 2 + 1 = 7`. Y finalmente se mantienen los permisos que tienen los otros usuarios, que por lo obtenido tras la ejecución del comando `ls -la` deben ser `r-x`, es decir lectura y ejecución (4 y 1), equivalentes a 5.

En el primer argumento se especifican los permisos en el orden mencionado anteriormente, es decir: `chmod <owner><group><Others> <directory name>`, por lo que al usar los valores númericos que representan los permisos se tiene: `chmod 775 <directory name>`. El último argumento (`<directory name>`), se usa para indicar el directorio o archivo sobre el cual se deben aplicar los cambios.

Si quieres aprender más acerca de cómo usar el comando `chmod`, te invitamos a leer el articulo titulado [Linux permissions: An introduction to chmod](https://www.redhat.com/sysadmin/introduction-chmod).

Ahora solo resta crear los 100 archivos con la estructura indicada. Esto se puede hacer de 2 formas, aunque en ambas se va a usar el comando `touch` como se muestra a continuación:

```bash
touch archivo-1.txt
```

**Nota:** Antes de ejecutar este comando no olvides entrar al directorio usando el comando: `cd guias/`

La primera forma de resolver este dilema es repitiendo este proceso 100 veces hasta completar el proceso, cambiando en cada iteración el nombre del archivo:

```bash
$ touch archivo-2.txt
$ touch archivo-3.txt
...

...
$ touch archivo-99.txt
$ touch archivo-100.txt
```

De la misma forma puedes definri un rango de nombres usando las herramientas que bash scripting incluye para ti, como por ejemplo:

```bash
touch archivo-{1..100}.txt
```

En este caso debes tener en cuenta que los nombres de todos los archivos tienen una parte estática y una parte variable. Lo que se mantiene de forma estática se compone de 2 partes, la primera es `archivo-`, y la segunda es `.txt`. Lo que varía es el número que va en medio de ambas partes. Para representarlo de forma sencilla se define un rango de datos, que se expresa de la siguiente forma: `{1..100}`. Al juntar ambas cosas se conforma el comando presentado anteriormente.

**Nota:** Si quieres validar que esto funcionecorrectamente, puedes usar el comando `echo` (`echo archivo-{1..10}.txt`)

Y la segunda forma de solucionar este punto es usando un script en bash como el siguiente:

```bash
#!/usr/bin/bash

# crear el directorio raiz
mkdir guias

# Asignar los permisos al directorio
chmod 775 guias

# crear los 100 archivos dentro del directorio raiz
for NUMBER in {1..100};
do
   touch guias/archivo-$NUMBER.txt;
done

# Comprobar que los archivos se crearon exitosamente
echo Se crearon $(ls guias/ | wc -l) archivos en el directorio guias
```

---
## 7. Copiado de archivos

En cada servidor creen una subcarpeta llamada `/guias/config` y copien en esta ubicación los archivos `/etc/redhat-release`, `/etc/passwd` y `/usr/share/dict/linux.words`.

Usa el siguiente comando para crear la subcarpeta en la ruta especificada:

```bash
mkdir -p ~/guias/config
```

- `mkdir`: comando para crear directorios.
- `-p`: crea la carpeta y cualquier subcarpeta necesaria (en este caso, guias y config).

Una vez creada la subcarpeta, copia los archivos indicados a `/guias/config`:

Ejecuta el siguiente comando para copiar el archivo `/etc/redhat-release`:

```bash
sudo cp /etc/redhat-release ~/guias/config/
```

Luego, copia el archivo `/etc/passwd` con el siguiente comando:

```bash
sudo cp /etc/passwd ~/guias/config/
```

Si después de esto copias el archivo `/usr/share/dict/linux.words`, verás un mensaje de error como el que se muestra a continuación:

```bash
$ sudo cp /usr/share/dict/linux.words ~/guias/config/
cp: cannot stat '/usr/share/dict/linux.words': No such file or directory
```

Para solucionarlo, lo primero que se debe hacer es instalar el paquete words:

```bash
yum install words
```

Una vez completada la instalación podrás proceder a hacer nuevamente la instalación del archivo `/usr/share/dict/linux.words`, y esta vez no deberías encontrar ningún error.

- `cp`: comando para copiar archivos.
- `/etc/redhat-release`, `/etc/passwd`, `/usr/share/dict/linux.words`: archivos de origen que deben ser copiados.
- `~/guias/config/`: destino de los archivos.

Para confirmar que los archivos fueron copiados correctamente, puedes usar el comando `ls`:

```bash
$ ls -l ~/guias/config/
total 4848
-rw-r--r--. 1 root root 4953598 Sep 30 05:07 linux.words
-rw-r--r--. 1 root root    2056 Sep 30 05:02 passwd
-rw-r--r--. 1 root root      44 Sep 30 05:01 redhat-release
```

Esto debería mostrar una lista con los archivos copiados en la carpeta `~/guias/config`.

---
## 8. Versión del sistema operativo

En cada servidor almacenen la versión exacta del sistema operativo en el archivo `/tmp/os-version.txt`.

En la mayoría de los sistemas Linux, puedes obtener la versión exacta del sistema operativo utilizando el comando `cat` en los siguientes archivos:

- Para distribuciones basadas en **Red Hat**, el archivo es `/etc/redhat-release`.
- Para distribuciones **Debian/Ubuntu**, el archivo es `/etc/os-release`.

Ejecuta el siguiente comando para mostrar la versión del sistema operativo:

```bash
cat /etc/redhat-release
```

Una vez que obtienes la versión del sistema operativo, almacénala en el archivo `/tmp/os-version.txt`. Ejecuta este comando para redirigir el contenido de `/etc/redhat-release` al archivo `/tmp/os-version.txt`:

```bash
cat /etc/redhat-release > /tmp/os-version.txt
```

Después de ejecutar el comando, verifica que el archivo `/tmp/os-version.txt` contiene la versión correcta del sistema operativo:

```bash
cat /tmp/os-version.txt
```

---
## 9. Enlaces simbolicos

En cada servidor creen un enlace simbólico llamado `/guias/config/grupos` apuntando al archivo `/etc/group`.

Utiliza el comando `ln -s` para crear el enlace simbólico que apunte al archivo `/etc/group`.

```bash
sudo ln -s /etc/group ~/guias/config/grupos
```

- `ln -s`: Crea un enlace simbólico.
- `/etc/group`: Archivo original al que se apunta.
- `/guias/config/grupos`: Nombre y ubicación del enlace simbólico.

Para asegurarte de que el enlace simbólico fue creado correctamente, usa el comando `ls -l` para listar el contenido de la carpeta `/guias/config/`:

```bash
$ ls -l ~/guias/config/
total 4848
lrwxrwxrwx. 1 root root      10 Sep 30 05:25 grupos -> /etc/group
-rw-r--r--. 1 root root 4953598 Sep 30 05:07 linux.words
-rw-r--r--. 1 root root    2056 Sep 30 05:02 passwd
-rw-r--r--. 1 root root      44 Sep 30 05:01 redhat-release
```

Debes ver algo como lo siguiente en la salida:

```bash
lrwxrwxrwx. 1 root root      10 Sep 30 05:25 grupos -> /etc/group
```

El `-> /etc/group` indica que el enlace simbólico grupos apunta al archivo `/etc/group`.


---
## 10. Banner de inicio de seisón en Linux

En cada servidor incluyan el mensaje **"El problema no es problema"** en el archivo `/etc/motd`, para que cuando un usuario haga login se muestra el MOTD (mensaje del dia).

**¿Qué es el MOTD?**: El archivo `/etc/motd` (Message of the Day o Mensaje del Día) se utiliza para mostrar un mensaje cada vez que un usuario inicia sesión en el sistema. Este mensaje puede incluir información importante, recordatorios o mensajes personalizados.

El archivo `/etc/motd` puede editarse directamente para incluir el mensaje deseado. Usa un editor de texto como `vim`, `nano` o redirige el mensaje al archivo directamente.

### Opción 1: Editar el Archivo Directamente

Usa el siguiente comando para abrir el archivo con el editor `vim`:

```bash
sudo vim /etc/motd
```

De la misma forma en la que se ha trabajado anteriormente, sigue los siguientes pasos:
- Presiona la tecla `i` para poder insertar texto en el archivo.
- Escribe el mensaje: `El problema no es problema`. Luego de esto preciona.
- Presiona la tecla `Esc`.
- Escribe `:x` (para realizar el guardado inteligente del archivo editado).

### Opción 2: Usar un Comando para Agregar el Mensaje

Si prefieres usar un comando, puedes redirigir el mensaje directamente al archivo con el siguiente comando:

```bash
echo "El problema no es problema" | sudo tee /etc/motd
```

Este comando asegura que el mensaje se escriba en el archivo /etc/motd, reemplazando cualquier contenido anterior.

### Verificar el Mensaje en el Archivo `/etc/motd`

Después de agregar el mensaje, puedes verificar el contenido del archivo para asegurarte de que el mensaje se guardó correctamente:

```bash
$ cat /etc/motd
El problema no es problema
```

Para asegurarte de que el mensaje se muestre correctamente al iniciar sesión, puedes cerrar la sesión actual y volver a iniciar sesión o usar un cliente SSH para conectarte al servidor. O bien puedes realizar una conexión por ssh con el mismo servidor como se muestra a continuación:

```bash
$ ssh compras@localhost
El problema no es problema
```

Al iniciar sesión, el mensaje "El problema no es problema" aparecerá antes del prompt de la terminal.

---
## 11. Particiones y puntos de montaje

En cada servidor listen las particiones y los puntos de montaje del sistema operativo y envíen la salida al archivo `/tmp/particiones.txt`.

Para listar las particiones y sus puntos de montaje en un sistema Linux, puedes usar el comando `df -h`. Este comando muestra el uso del disco de una manera legible para el ser humano (en GB o MB).

Ejecuta el siguiente comando para ver las particiones y los puntos de montaje:

```bash
df -h
```

A continuación podrás observar un ejemplo de la salida del comando `df -h`:

```bash
$ df -h 
Filesystem                 Size  Used Avail Use% Mounted on
devtmpfs                   4.0M     0  4.0M   0% /dev
tmpfs                      3.8G     0  3.8G   0% /dev/shm
tmpfs                      1.6G  8.8M  1.5G   1% /run
/dev/mapper/rootvg-rootlv  2.0G   70M  1.9G   4% /
/dev/mapper/rootvg-usrlv    10G  1.6G  8.4G  16% /usr
/dev/sda2                  436M  217M  220M  50% /boot
/dev/mapper/rootvg-homelv  960M   40M  921M   5% /home
/dev/mapper/rootvg-tmplv   2.0G   47M  1.9G   3% /tmp
/dev/mapper/rootvg-varlv   8.0G  262M  7.7G   4% /var
/dev/sda1                  200M  7.0M  193M   4% /boot/efi
/dev/sdb1                   16G   36K   15G   1% /mnt
tmpfs                      769M     0  769M   0% /run/user/1002
```

Ahora, redirigimos la salida del comando anterior al archivo `/tmp/particiones.txt` usando el operador `>`.

```bash
df -h > /tmp/particiones.txt
```

Este comando guardará el resultado del listado de particiones en el archivo `/tmp/particiones.txt`. Si el archivo ya existe, lo sobrescribirá. Para asegurarte de que la información se guardó correctamente, puedes usar el comando `cat` para visualizar el contenido del archivo:

```bash
cat /tmp/particiones.txt
```


---
## 12. Cada servidor debe tener un total de 25 GB de almacenamiento utilizable.

Cada servidor debe tener un total de 25 GB de almacenamiento utilizable **(Servidor BD ya tiene montado el disco)**.

- https://www.redhat.com/sysadmin/resize-lvm-simple

```bash
$ df -h
Filesystem                 Size  Used Avail Use% Mounted on
devtmpfs                   4.0M     0  4.0M   0% /dev
tmpfs                      3.8G     0  3.8G   0% /dev/shm
tmpfs                      1.6G  8.8M  1.5G   1% /run
/dev/mapper/rootvg-rootlv  2.0G   70M  1.9G   4% /
/dev/mapper/rootvg-usrlv    10G  1.6G  8.4G  16% /usr
/dev/sda2                  436M  217M  220M  50% /boot
/dev/mapper/rootvg-homelv  960M   40M  921M   5% /home
/dev/mapper/rootvg-tmplv   2.0G   47M  1.9G   3% /tmp
/dev/mapper/rootvg-varlv   8.0G  262M  7.7G   4% /var
/dev/sda1                  200M  7.0M  193M   4% /boot/efi
/dev/sdb1                   16G   36K   15G   1% /mnt
tmpfs                      769M     0  769M   0% /run/user/1002
```

```bash
$ fdisk -l
Disk /dev/sda: 64 GiB, 68719476736 bytes, 134217728 sectors
Disk model: Virtual Disk    
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: B515128F-68A1-4508-85E7-DDA3051035B1

Device       Start       End   Sectors  Size Type
/dev/sda1     2048    411647    409600  200M EFI System
/dev/sda2   411648   1435647   1024000  500M Linux filesystem
/dev/sda3  1435648   1437695      2048    1M BIOS boot
/dev/sda4  1437696 134215679 132777984 63.3G Linux LVM


Disk /dev/sdb: 16 GiB, 17179869184 bytes, 33554432 sectors
Disk model: Virtual Disk    
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0xef618777

Device     Boot Start      End  Sectors Size Id Type
/dev/sdb1        2048 33552383 33550336  16G  7 HPFS/NTFS/exFAT


Disk /dev/mapper/rootvg-tmplv: 2 GiB, 2147483648 bytes, 4194304 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes


Disk /dev/mapper/rootvg-usrlv: 10 GiB, 10737418240 bytes, 20971520 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes


Disk /dev/mapper/rootvg-homelv: 1 GiB, 1073741824 bytes, 2097152 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes


Disk /dev/mapper/rootvg-varlv: 8 GiB, 8589934592 bytes, 16777216 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes


Disk /dev/mapper/rootvg-rootlv: 2 GiB, 2147483648 bytes, 4194304 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes


Disk /dev/sdc: 10 GiB, 10737418240 bytes, 20971520 sectors
Disk model: Virtual Disk    
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
```

```bash
$ lsblk
NAME              MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                 8:0    0   64G  0 disk 
├─sda1              8:1    0  200M  0 part /boot/efi
├─sda2              8:2    0  500M  0 part /boot
├─sda3              8:3    0    1M  0 part 
└─sda4              8:4    0 63.3G  0 part 
  ├─rootvg-tmplv  253:0    0    2G  0 lvm  /tmp
  ├─rootvg-usrlv  253:1    0   10G  0 lvm  /usr
  ├─rootvg-homelv 253:2    0    1G  0 lvm  /home
  ├─rootvg-varlv  253:3    0    8G  0 lvm  /var
  └─rootvg-rootlv 253:4    0    2G  0 lvm  /
sdb                 8:16   0   16G  0 disk 
└─sdb1              8:17   0   16G  0 part /mnt
sdc                 8:32   0   10G  0 disk 
sr0                11:0    1  634K  0 rom
```

```bash
$ pvcreate /dev/sdc
  Physical volume "/dev/sdc" successfully created.
```

```bash
$ vgs
  VG     #PV #LV #SN Attr   VSize  VFree 
  rootvg   1   5   0 wz--n- 63.31g 40.31g
```

```bash
$ vgextend rootvg /dev/sdc
  Volume group "rootvg" successfully extended
```

```bash
vgs
  VG     #PV #LV #SN Attr   VSize   VFree  
  rootvg   2   5   0 wz--n- <73.31g <50.31g
```

```bash
$ vgdisplay
  --- Volume group ---
  VG Name               rootvg
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  7
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                5
  Open LV               5
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               <73.31 GiB
  PE Size               4.00 MiB
  Total PE              18767
  Alloc PE / Size       5888 / 23.00 GiB
  Free  PE / Size       12879 / <50.31 GiB
  VG UUID               2Wht5S-7iTM-Bqye-trYS-kuZt-H2d1-isF0fT
```

```bash
$ lvs
  LV     VG     Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  homelv rootvg -wi-ao----  1.00g                                                    
  rootlv rootvg -wi-ao----  2.00g                                                    
  tmplv  rootvg -wi-ao----  2.00g                                                    
  usrlv  rootvg -wi-ao---- 10.00g                                                    
  varlv  rootvg -wi-ao----  8.00g
```

```bash
$ lvextend -l +100%FREE /dev/rootvg/usrlv
  Size of logical volume rootvg/usrlv changed from 10.00 GiB (2560 extents) to <60.31 GiB (15439 extents).
  Logical volume rootvg/usrlv successfully resized.
```

```bash
$ xfs_growfs /dev/rootvg/usrlv 
meta-data=/dev/mapper/rootvg-usrlv isize=512    agcount=4, agsize=655360 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=2621440, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 2621440 to 15809536
```

```bash
$ df -h
Filesystem                 Size  Used Avail Use% Mounted on
devtmpfs                   4.0M     0  4.0M   0% /dev
tmpfs                      3.8G     0  3.8G   0% /dev/shm
tmpfs                      1.6G  8.8M  1.5G   1% /run
/dev/mapper/rootvg-rootlv  2.0G   70M  1.9G   4% /
/dev/mapper/rootvg-usrlv    61G  2.0G   59G   4% /usr
/dev/sda2                  436M  217M  220M  50% /boot
/dev/mapper/rootvg-homelv  960M   40M  921M   5% /home
/dev/mapper/rootvg-tmplv   2.0G   47M  1.9G   3% /tmp
/dev/mapper/rootvg-varlv   8.0G  263M  7.7G   4% /var
/dev/sda1                  200M  7.0M  193M   4% /boot/efi
/dev/sdb1                   16G   36K   15G   1% /mnt
tmpfs                      769M     0  769M   0% /run/user/1002
tmpfs                      769M     0  769M   0% /run/user/1000
```

---
## 13. De cada servidor indiquen qué sistema de archivos tiene su partición `/`.

El comando `df -Th` puede ser utilizado para listar las particiones montadas junto con el tipo de sistema de archivos. Ejecuta el siguiente comando para obtener el tipo de sistema de archivos de la partición `/`:

```bash
$ df -Th | grep ' /$'
/dev/mapper/rootvg-rootlv xfs       2.0G   70M  1.9G   4% /
```

- La opción `-T`: Se usa para mostrar el tipo de sistema de archivos.
- La opción `-h`: Muestra los tamaños de disco de forma legible para los humanos.
- La tubería `| grep ' /$'`: Filtra solo la línea correspondiente a la partición raíz `/`.

Otra forma de verificar el sistema de archivos de la partición `/` es con el comando `mount`. Este comando muestra las particiones montadas y sus sistemas de archivos. Ejecuta el siguiente comando para obtener la información de la partición `/`:

```bash
$ mount | grep ' on / '
/dev/mapper/rootvg-rootlv on / type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
```

Este comando buscará la línea donde aparece montada la partición raíz / y mostrará su sistema de archivos.
