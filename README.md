# zig-bf

Brainfuck interpreter in Zig. Example: mandelbrot.b

```
$ jenga build
$ time ,jenga/main
```

Baseline time: 20.35s

Final #steps:10712557522

Plan: Explore use of `comptime` for partial evaluation.
