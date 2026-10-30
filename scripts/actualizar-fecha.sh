#!/usr/bin/env bash
#
# Actualiza la fecha de verificación de la oferta en todas las páginas.
#
# Uso:
#   ./scripts/actualizar-fecha.sh              # usa la fecha de hoy
#   ./scripts/actualizar-fecha.sh 2026-11-15   # usa una fecha concreta
#
# La fuente de verdad es FECHA-VERIFICACION.txt (formato ISO).
# Ejecútalo cuando hayas comprobado que la oferta sigue vigente.

set -euo pipefail

cd "$(dirname "$0")/.."

ARCHIVO_FECHA="FECHA-VERIFICACION.txt"

if [ ! -f "$ARCHIVO_FECHA" ]; then
  echo "Error: no existe $ARCHIVO_FECHA" >&2
  exit 1
fi

NUEVA_ISO="${1:-$(date +%Y-%m-%d)}"
VIEJA_ISO=$(tr -d '[:space:]' < "$ARCHIVO_FECHA")

if ! [[ "$NUEVA_ISO" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
  echo "Error: formato esperado YYYY-MM-DD (recibido: $NUEVA_ISO)" >&2
  exit 1
fi

MESES=(enero febrero marzo abril mayo junio julio agosto septiembre octubre noviembre diciembre)

a_texto() {
  local iso="$1"
  local anio resto mes dia
  anio=${iso%%-*}
  resto=${iso#*-}
  mes=${resto%%-*}
  dia=${resto#*-}
  if [ "$((10#$mes))" -lt 1 ] || [ "$((10#$mes))" -gt 12 ]; then
    echo "Error: mes inválido en $iso" >&2
    exit 1
  fi
  echo "$((10#$dia)) de ${MESES[$((10#$mes - 1))]} de $anio"
}

VIEJA_TXT=$(a_texto "$VIEJA_ISO")
NUEVA_TXT=$(a_texto "$NUEVA_ISO")

echo "Antes: $VIEJA_TXT"
echo "Ahora: $NUEVA_TXT"

if [ "$VIEJA_TXT" = "$NUEVA_TXT" ]; then
  echo "Sin cambios: la fecha ya está actualizada."
  exit 0
fi

mapfile -t ARCHIVOS < <(grep -rl --include="*.html" --include="*.txt" --include="*.md" -F "$VIEJA_TXT" . || true)

if [ ${#ARCHIVOS[@]} -eq 0 ]; then
  echo "Error: no se encontró «$VIEJA_TXT» en ningún archivo." >&2
  exit 1
fi

for f in "${ARCHIVOS[@]}"; do
  sed -i "s|$VIEJA_TXT|$NUEVA_TXT|g" "$f"
  echo "  actualizado: ${f#./}"
done

printf '%s\n' "$NUEVA_ISO" > "$ARCHIVO_FECHA"
echo
echo "Listo. Ahora:"
echo "  git add -A && git commit -m \"Verifica la oferta: $NUEVA_TXT\" && git push"
