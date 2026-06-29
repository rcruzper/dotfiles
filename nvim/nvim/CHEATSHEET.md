# Neovim cheatsheet

Atajos configurados en este dotfiles. **Leader = `,`**.

> Convención: `,x` significa primero `,`, luego `x`. `<c-x>` = Ctrl+X. `<s-x>` = Shift+X.

---

## Pickers (snacks.picker)

### Top-level
| Atajo | Acción |
|-------|--------|
| `,,` | Buffers (MRU) |
| `,/` | Grep en root del proyecto |
| `,:` | Historial de comandos |
| `,<space>` | Find files en root |
| `,n` | Historial de notificaciones |
| `,?` | Mostrar atajos del buffer actual (which-key) |

### Find (`,f*`)
| Atajo | Acción |
|-------|--------|
| `,ff` / `,fF` | Find files (root / cwd) |
| `,fb` / `,fB` | Buffers (MRU / todos incluyendo nofile) |
| `,fg` | Git files |
| `,fr` / `,fR` | Recent files (root / cwd) |

### Search (`,s*`)
| Atajo | Acción |
|-------|--------|
| `,sb` | Líneas del buffer actual |
| `,sB` | Grep en buffers abiertos |
| `,sg` / `,sG` | Grep (root / cwd) |
| `,sw` / `,sW` | Palabra bajo cursor (root / cwd) |
| `,sh` | Help tags |
| `,sk` | Keymaps |
| `,sd` / `,sD` | Diagnostics (workspace / buffer) |
| `,sm` | Marks |
| `,sj` | Jumps |
| `,sl` / `,sq` | Loclist / Quickfix |
| `,sR` | Resume última búsqueda |
| `,su` | Undotree |
| `,sp` | Buscar plugin spec |
| `,sa` | Autocommands |
| `,si` | Iconos |
| `,sH` | Highlight groups |
| `,sM` | Man pages |
| `,sc` / `,sC` | Command history / Commands |
| `,s/` | Search history |
| `,s"` | Registers |

### Git (`,g*`)
| Atajo | Acción |
|-------|--------|
| `,gs` | Git status |
| `,gS` | Git stash |
| `,gl` | Git log |
| `,gd` | Git diff (hunks) |

### Git hunks (gitsigns, `,gh*`)
| Atajo | Acción |
|-------|--------|
| `]h` / `[h` | Siguiente / anterior hunk |
| `]H` / `[H` | Último / primer hunk |
| `,ghs` | Stage hunk (n/x) |
| `,ghr` | Reset hunk (n/x) |
| `,ghS` | Stage buffer entero |
| `,ghu` | Undo stage hunk |
| `,ghR` | Reset buffer entero |
| `,ghp` | Preview hunk inline |
| `,ghb` | Blame línea (popup con info completa) |
| `,ghB` | Blame buffer entero |
| `,ghd` | Diff this (vs index) |
| `,ghD` | Diff this ~ (vs commit anterior) |
| `ih` | Textobject hunk (ej. `dih` borra el hunk bajo cursor) |

### UI (`,u*`)
| Atajo | Acción |
|-------|--------|
| `,uC` | Picker de colorschemes |
| `,un` | Descartar todas las notificaciones visibles |
| `,uz` | Toggle zen mode (distracción-free) |
| `,uZ` | Toggle zoom (pantalla completa de la ventana actual) |

### Buffer (`,b*`)
| Atajo | Acción |
|-------|--------|
| `,bb` | Switch a buffer alterno (último visitado) |
| `,bd` | Cerrar buffer (preserva ventana) |
| `,bo` | Cerrar otros buffers |
| `,bi` | Cerrar buffers invisibles |
| `,bD` | Cerrar buffer y ventana |

### Terminal
| Atajo | Modo | Acción |
|-------|------|--------|
| `<c-/>` o `<c-_>` | n/t | Toggle terminal flotante en root dir |
| `<c-h>`/`<c-j>`/`<c-k>`/`<c-l>` | t | Saltar a ventana adyacente desde terminal |

---

## LSP (en buffers con server activo)

Servidor TS: `vtsls` (con `maxTsServerMemory=8192` para el monorepo).

### Navegación
| Atajo | Acción |
|-------|--------|
| `gd` | Goto Definition (con preview vía snacks.picker) |
| `gr` | References |
| `gI` | Goto Implementation |
| `gy` | Goto Type Definition |

### Hover & info
| Atajo | Modo | Acción |
|-------|------|--------|
| `K` | n | Hover |
| `gK` | n | Signature help (popup) |

### Code actions (`,c*`)
| Atajo | Acción |
|-------|--------|
| `,cr` | Rename symbol |
| `,ca` | Code Action (genérico) |
| `,cf` | Format buffer (conform → fallback al LSP si no hay formatter) |
| `,cd` | Mostrar diagnostic bajo cursor en float |
| `,co` | Organize imports |

### Diagnostics
| Atajo | Acción |
|-------|--------|
| `[d` / `]d` | Prev / next diagnostic |
| `,sd` | Picker de diagnostics del workspace |
| `,sD` | Picker de diagnostics del buffer |

---

## Format & Lint

### Formato (conform.nvim)

- **Format on save**: activo. Al `:w` un fichero soportado, se reformatea automáticamente
- **`,cf`** (n/v) formatea manualmente. Si la selección visual está, formatea sólo el rango

Formatters por filetype:

| Filetype | Formatter |
|----------|-----------|
| TS/TSX/JS/JSX/JSON/JSONC/YAML/MD/CSS/HTML | Prettier (lee `.prettierrc` del proyecto) |
| Lua | stylua |
| sh / bash | shfmt |
| Otros | Fallback al LSP si el server lo soporta |

### Lint (nvim-lint)

ESLint corre en TS/TSX/JS/JSX vía `eslint_d` (daemon, instantáneo después de la primera invocación). Lee la config ESLint por paquete (flat o legacy — cwd se ajusta automáticamente al directorio que la contiene).

Triggers automáticos: `BufWritePost`, `BufReadPost`, `InsertLeave`.

Resultados aparecen en gutter, `,cd` (float), `,sd`/`,sD` (picker) y panel Trouble.

Para arreglos: `,ca` sobre un warning → code action de ESLint (si la regla tiene autofix).

---

## Autocompletado (blink.cmp)

Sources activos: `lsp` (vtsls) · `path` (paths cuando escribes `./`, `~/`, etc.) · `buffer` (palabras de buffers abiertos). **Sin snippets** (decisión).

### En insert mode (cuando el menú está visible)

| Atajo | Acción |
|-------|--------|
| `<C-Space>` | Forzar mostrar menú |
| `<CR>` o `<C-y>` | Aceptar selección |
| `<C-n>` / `<C-p>` | Siguiente / anterior |
| `<Tab>` / `<S-Tab>` | Siguiente / anterior (alternativo) |
| `<C-e>` | Cerrar menú |
| `<C-b>` / `<C-f>` | Scroll documentación (lateral del menú) |

### En cmdline (`:` mode)

Auto-show del menú al escribir comandos. Sin pre-selección — usas `<Tab>` para elegir, `<CR>` para ejecutar. Ghost text como preview de la sugerencia.

### Auto-brackets

Cuando aceptas una completion de función (LSP), se añaden los `()` automáticamente si la función los necesita. Cursor queda dentro listo para argumentos.

---

## Movimiento rápido (flash.nvim)

| Atajo | Modo | Acción |
|-------|------|--------|
| `s` | n/x/o | Flash jump (escribes 1-2 chars, salta con la etiqueta) |
| `S` | n/x/o | Flash treesitter (etiqueta nodos AST: funciones/clases/etc.) |
| `r` | o (operator-pending) | Remote flash (operar a distancia: `dr` + jump + objeto) |
| `R` | o/x | Treesitter search (búsqueda sobre nodos) |
| `<c-s>` | c (cmdline) | Toggle flash dentro de `/` `?` |
| `<c-space>` | n/o/x | Selección incremental por AST (treesitter) |

---

## TODO comments (todo-comments.nvim)

Resalta `TODO`/`FIX`/`FIXME`/`HACK`/`WARN`/`NOTE`/`PERF`/`TEST` con colores distintos.

| Atajo | Acción |
|-------|--------|
| `]t` / `[t` | Siguiente / anterior TODO comment |
| `,st` | Picker de todos los TODOs del proyecto |
| `,sT` | Picker filtrado a TODO/FIX/FIXME |

---

## Comentar (ts-comments.nvim)

Sustituye el comentado built-in con detección de contexto vía treesitter. Útil sobre todo en JSX/TSX (usa `{/* */}` dentro de bloques JSX automáticamente).

| Atajo | Acción |
|-------|--------|
| `gcc` | Toggle comentario en la línea (vim built-in, mejorado por ts-comments) |
| `gc{motion}` | Toggle comentario en motion (ej. `gcap` un párrafo) |
| `gc` en visual | Toggle comentario en selección |

---

## Treesitter

### Movimiento por estructura (textobjects)
| Atajo | Salta a |
|-------|---------|
| `]f` / `[f` | Siguiente / anterior función (inicio) |
| `]F` / `[F` | Siguiente / anterior función (final) |
| `]c` / `[c` | Siguiente / anterior clase |
| `]a` / `[a` | Siguiente / anterior argumento |

### Folds
| Atajo | Acción |
|-------|--------|
| `zc` / `zo` / `za` | Cerrar / abrir / toggle fold bajo cursor |
| `zM` / `zR` | Cerrar / abrir todos los folds |

---

## Textobjects extendidos (mini.ai)

Combinar con operador (`v` selección, `d` borrar, `c` cambiar, `y` copiar) + `i` (inner) o `a` (around):

| Identificador | Selecciona |
|---|---|
| `if` / `af` | función |
| `ic` / `ac` | clase |
| `io` / `ao` | bloque (if/for/while) |
| `it` / `at` | tag JSX/HTML |
| `id` / `ad` | dígito |
| `iu` / `au` | función llamada (`foo.bar(x)`) |
| `iU` / `aU` | función llamada sin `.` (sólo el nombre) |

Ejemplos: `vif` selecciona función completa, `dau` borra una llamada `foo()`, `cit` cambia contenido de tag JSX.

---

## Surround (mini.surround, prefix `gs*`)

| Comando | Acción |
|---------|--------|
| `gsa{textobject}{char}` | Añadir surround. Ej: `gsaiw"` envuelve la palabra en `"` |
| `gsd{char}` | Borrar surround |
| `gsr{old}{new}` | Reemplazar surround. Ej: `gsr"'` cambia `"` por `'` |
| `gsf` / `gsF` | Encontrar surround a la derecha / izquierda |
| `gsh` | Resaltar surround temporalmente |
| `gsn` | Actualizar `n_lines` config |

---

## Scope (snacks.scope)

| Atajo | Acción |
|-------|--------|
| `vii` / `vai` | Seleccionar inner / full scope |
| `[i` / `]i` | Saltar a borde superior / inferior del scope |

---

## Autopairs (mini.pairs)

Activo en insert mode. Escribir `(` autocompleta `()` con cursor entre paréntesis. Aplica a `()`, `[]`, `{}`, `""`, `''`, `` ` ``.

---

## Ventanas

| Atajo | Acción |
|-------|--------|
| `<c-w><space>` | Modo hydra de ventanas (which-key loop) |
| `,w` | Grupo de ventanas (proxy a `<c-w>`) |

---

## Otros

| Atajo | Acción |
|-------|--------|
| `gx` | Abrir URL/path bajo cursor con app del sistema |

---

## Trouble (trouble.nvim)

Panel navegable de diagnostics / referencias / symbols / quickfix / loclist. Complementa `,sd`/`,sD` (pickers de snacks): los pickers son fuzzy-find one-shot, Trouble es una vista persistente que puedes mantener abierta a la derecha mientras navegas.

### Diagnostics & listas (`,x*`)
| Atajo | Acción |
|-------|--------|
| `,xx` | Toggle diagnostics del workspace |
| `,xX` | Toggle diagnostics del buffer actual |
| `,xL` | Toggle location list |
| `,xQ` | Toggle quickfix list |

### Code (`,c*`)
| Atajo | Acción |
|-------|--------|
| `,cs` | Toggle symbols del buffer (panel derecho, no roba foco) |
| `,cS` | Toggle LSP references/definitions/impl/typeDef (panel derecho) |

### Navegación
| Atajo | Acción |
|-------|--------|
| `]q` / `[q` | Siguiente / anterior item. Si Trouble está abierto, salta dentro del panel; si no, fallback a `:cnext` / `:cprev` |

Dentro del panel Trouble: `<cr>` jump, `q` cerrar, `?` ayuda con todos los keymaps.

---

## Pendientes (cuando lleguen sus fases)

| Fase | Plugin | Atajos previstos |
|------|--------|-------------------|
| 13 | snacks.lazygit | `,gg` lazygit floating |
| 14 | snacks.explorer | `,fe` / `,fE` explorer (root / cwd) |
| 15 | DAP | `,d*` debug, `,dp*` profiler |
