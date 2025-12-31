# Generación de un archivo requirements.txt para un Jupyter Notebook

En ciencia de datos como en todas la ciencias, la reproducibilidad es un factor importante porque permite que otras personas puedan repetir un análisis y obtener los mismos resultados, usando los mismos datos y pasos. Esto ayuda a comprobar que el trabajo está bien hecho y que las conclusiones son confiables. Además, facilita corregir errores, mejorar los análisis y aprender de ellos. Es por esto, que crear un archivo *requirements.txt* es un proceso necesario, particularmente cuando se comparte el código, pues se reduce la probabilidad de problemas de compatibilidad.

Una de los métodos más directos es utilizar `pip freeze`, el cual lista todos los paquetes y versiones del ambiente virtual que se esté utilizando. Los pasos son simples:

1. Abrir la terminal y activar el ambiente virtual.
2. Ejecutar `pip freeze > requirements.txt`

El problema con este método es que toma todos los paquetes que estén instalados en el ambiente seleccionado. Luego, si solo se necesita que el archivo requirements.txt se relacione solo con el notebook y no con todo el entorno, entonces la mejor forma de hacerlo es usando Pipreqs.

## Generar requirements.txt con Pipreqs

1. Abrir la terminal, activar el ambiente e instalar pipreqs y nbconvert en caso de no estar instalados.
   - `pip install pipreqs`
   - `pip install nbconvert`

2. Navegar hasta la carpeta donde se encuentra el Jupyter notebook, para este caso *my_notebook.ipynb* y ejecutar:
  - `jupyter nbconvert --output-dir="./reqs" --to script my_notebook.ipynb`  
  Este comando convierte el notebook en un archivo *.py* y lo guarda en un nuevo directorio llamado **reqs**

3. Ir al directorio **reqs** y ejecutar el siguiente comando:
  - `pipreqs`
  El comando anterior genera automáticamente el archivo *requirements.txt* dentro de la misma carpeta.

Al revisar el archivo se debe ver algo como esto:

```
matplotlib==3.7.5
numpy==1.25.0
pandas==2.3.3
```

## Instalar las Dependencias desde requirements.txt
Al configurar el proyecto en otro sistema, una vez generado el ambiente, desde Conda ejecutar el siguiente comando:
- `conda install --file requirements.txt`

O desde pip:
- `pip install -r requisitos.txt`

Esto garantiza que todos los paquetes necesarios se instalen con las versiones especificadas.



