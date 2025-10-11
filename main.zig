const std = @import("std");
const debug = std.debug;
const print = debug.print;
const prog = @embedFile("mandelbrot.b");
pub fn main() !void {
    var mem = [_]u8{0} ** 30_000;
    var ip: usize = 0;
    var mp: usize = 0;
    var step : usize = 0;
    while (ip < prog.len) {
        step += 1;
        const op: u8 = prog[ip];
        //print("step:{d}, ip={d}, mp={d}, op='{c}'\n",.{step,ip,mp,op});
        ip += 1;
        switch(op) {
            '.' => print("{c}",.{mem[mp]}),
            '+' => mem[mp] +%= 1,
            '-' => mem[mp] -%= 1,
            '>' => mp += 1,
            '<' => mp -= 1,
            '[' => {
                if (mem[mp] == 0) {
                    var c = prog[ip];
                    var nest : usize = 0;
                    while (nest>0 or c != ']') {
                        if (c == '[') nest += 1;
                        if (c == ']') nest -= 1;
                        ip += 1;
                        c = prog[ip];
                    }
                    ip += 1;
                }
            },
            ']' => {
                if (mem[mp] != 0) {
                    ip -= 2;
                    var c = prog[ip];
                    var nest : usize = 0;
                    while (nest>0 or c != '[') {
                        if (c == ']') nest += 1;
                        if (c == '[') nest -= 1;
                        ip -= 1;
                        c = prog[ip];
                    }
                    ip += 1;
                }
            },
            else => {},
        }
    }
}
