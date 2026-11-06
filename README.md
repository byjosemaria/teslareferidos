# Tesla Referidos

Landing estática con mi enlace de referido de Tesla. Quien reserva un coche
desde el enlace recibe **1.000 km de Supercarga gratis**, y yo otros tantos.

**Enlace de referido:** <https://ts.la/josmara116770>

## Estructura

```
.
├── index.html                          Landing principal (CSS y JS inline)
├── 404.html                            Página de error (rutas absolutas)
├── guias/
│   ├── como-funciona-referidos-tesla.html
│   ├── calculadora-coste-carga.html
│   ├── codigo-referido-tesla.html
│   ├── cuanto-cuesta-cargar-un-tesla.html
│   └── model-3-vs-model-y.html
├── assets/
│   ├── og-image.png                    Imagen para compartir (1200×630)
│   └── autor.png                       Imagen del bloque de autor (600×600)
├── scripts/
│   └── actualizar-fecha.sh             Actualiza la fecha de verificación en todo el sitio
├── .github/
│   └── workflows/
│       └── recordatorio-verificacion.yml   Aviso mensual si la fecha se queda vieja
├── FECHA-VERIFICACION.txt              Fuente de verdad de la fecha (ISO)
├── robots.txt
├── sitemap.xml
├── .nojekyll                           Evita el procesado de Jekyll en GitHub Pages
├── file.txt                            Notas de estructura
└── informacionFAQ.txt                  Borrador de las preguntas frecuentes
```

Cada página HTML es **autocontenida**: no hay build, ni dependencias, ni
JavaScript externo. Se puede abrir `index.html` directamente en el navegador.

## Publicación en GitHub Pages

El sitio se publica desde la **raíz** del repositorio.

1. Crea un repositorio público llamado `teslareferidos` en GitHub.
2. Sube el contenido:

   ```bash
   git remote add origin git@github.com:byjosemaria/teslareferidos.git
   git push -u origin master
   ```

3. En el repositorio: **Settings → Pages → Source: Deploy from a branch →
   Branch: `master`, Folder: `/ (root)`**.
4. En uno o dos minutos estará en <https://byjosemaria.github.io/teslareferidos/>.

## Cambiar el enlace de referido

El enlace aparece en `index.html` (navbar, hero, CTA final y botones de copiar)
y en la barra superior y el bloque final de las tres guías. Para cambiarlo:

```bash
grep -rl "ts.la/josmara116770" --include="*.html" . | xargs sed -i 's|https://ts.la/josmara116770|NUEVO_ENLACE|g'
```

No olvides actualizar también `sitemap.xml` si cambia el dominio.

## Mantenimiento

- **Fecha de verificación:** el texto «Oferta comprobada el 6 de noviembre de 2026»
  aparece en el hero y en el pie de todas las páginas. La fuente de verdad es
  `FECHA-VERIFICACION.txt` (formato `AAAA-MM-DD`). Cuando compruebes que la
  oferta sigue vigente, ejecuta:

  ```bash
  ./scripts/actualizar-fecha.sh              # usa la fecha de hoy
  ./scripts/actualizar-fecha.sh 2026-11-15   # o una fecha concreta
  git add -A && git commit -m "Verifica la oferta" && git push
  ```

  El script reescribe la fecha en español en todos los HTML, el `README.md` y
  el `file.txt`, actualiza el atributo `data-fecha` (el que usa el JavaScript),
  `FECHA-VERIFICACION.txt` y `dateModified` del JSON-LD. No toca `datePublished`.

  **En pantalla se muestra en tiempo relativo**: «Oferta comprobada hoy»,
  «ayer», «hace 12 días», «hace 3 meses». Lo calcula un script inline en cada
  página a partir de `data-fecha`, así que cambia solo cada día sin intervención.
  Si el visitante no tiene JavaScript, ve la fecha absoluta escrita en el HTML.
  Al pasar el ratón por encima aparece la fecha exacta en el `title`.

  **No se actualiza sola a «hoy» a propósito.** El texto afirma que *tú* has
  comprobado la oferta ese día; si se pusiera la fecha de hoy cada mañana sería
  una afirmación falsa. Lo que cambia automáticamente es el tiempo transcurrido,
  que sí es un dato real. Para no olvidarlo, el workflow
  `recordatorio-verificacion.yml` se ejecuta el día 1 de cada mes y abre un
  issue si han pasado más de 45 días.

- Las cifras de precios y consumos de las guías son **orientativas**; conviene
  revisarlas cada temporada.
- Los términos del programa de referidos los fija Tesla y cambian a menudo.
  El texto usa fórmulas condicionales a propósito: no prometas cifras cerradas.
- La imagen `assets/og-image.png` se generó renderizando HTML con Chrome
  headless a 1200×630, y `assets/autor.png` a 600×600 con el mismo método.
- `404.html` usa rutas absolutas (`/teslareferidos/...`) porque GitHub Pages la
  sirve en cualquier profundidad de URL. Si algún día cambia el nombre del
  repositorio o se pasa a dominio propio, hay que actualizar esas rutas.
