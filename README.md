# Tesla Referidos

Landing estática con mi enlace de referido de Tesla. Quien reserva un coche
desde el enlace recibe **1.000 km de Supercarga gratis**, y yo otros tantos.

**Enlace de referido:** <https://ts.la/josmara116770>

## Estructura

```
.
├── index.html                          Landing principal (CSS y JS inline)
├── guias/
│   ├── como-funciona-referidos-tesla.html
│   ├── cuanto-cuesta-cargar-un-tesla.html
│   └── model-3-vs-model-y.html
├── assets/
│   └── og-image.png                    Imagen para compartir (1200×630)
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
   git remote add origin https://github.com/byjosemaria/teslareferidos.git
   git branch -M main
   git push -u origin main
   ```

3. En el repositorio: **Settings → Pages → Source: Deploy from a branch →
   Branch: `main`, Folder: `/ (root)`**.
4. En uno o dos minutos estará en <https://byjosemaria.github.io/teslareferidos/>.

## Cambiar el enlace de referido

El enlace aparece en `index.html` (navbar, hero, CTA final y botones de copiar)
y en la barra superior y el bloque final de las tres guías. Para cambiarlo:

```bash
grep -rl "ts.la/josmara116770" --include="*.html" . | xargs sed -i 's|https://ts.la/josmara116770|NUEVO_ENLACE|g'
```

No olvides actualizar también `sitemap.xml` si cambia el dominio.

## Mantenimiento

- Las cifras de precios y consumos de las guías son **orientativas**; conviene
  revisarlas cada temporada.
- Los términos del programa de referidos los fija Tesla y cambian a menudo.
  El texto usa fórmulas condicionales a propósito: no prometas cifras cerradas.
- La imagen `assets/og-image.png` se generó renderizando HTML con Chrome
  headless a 1200×630.
