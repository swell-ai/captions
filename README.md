_This was built on a mac m1: for various machines, changes may have to be made._

## Compile

```bash
sh ./scripts/compile
```

## Run command

```bash
./captions \
  --input input.mp4 \
  --segments segments.json \
  --output output.mp4 \
  --font "Montserrat ExtraBold 56" \
  --highlighter true \
  --text_color "#f6be0e"
```

or with hosted assets...

```bash
./captions \
  --input https://example.com/input.mp4 \
  --segments https://example.com/segments.json \
  --output output.mp4 \
  --font "Montserrat ExtraBold 56" \
  --highlighter true \
  --text_color "#f6be0e"
```
