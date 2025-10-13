const std = @import("std");
const debug = std.debug;
const print = debug.print;
const prog = @embedFile("mandelbrot.b");

var stdin_buffer: [1024]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(&stdin_buffer);
const stdin = &stdin_reader.interface;

pub fn main() void {
    precalculate_jumps();
    var mem = [_]u8{0} ** 30_000;
    var ip: usize = 0;
    var mp: usize = 0;
    var step : usize = 0;
    while (ip < prog.len) {
        step += 1;
        const op: u8 = prog[ip];
        //print("step:{d}, ip={d}, mp={d}, op='{c}'\n",.{step,ip,mp,op});
        switch(op) {
            ',' => mem[mp] = stdin.takeByte() catch 0,
            '.' => print("{c}",.{mem[mp]}),
            '+' => mem[mp] +%= 1,
            '-' => mem[mp] -%= 1,
            '>' => mp += 1,
            '<' => mp -= 1,
            //'[' => if (mem[mp] == 0) { ip = skip_right(ip+1); },
            //']' => if (mem[mp] != 0) { ip = skip_left(ip-1); },
            '[' => if (mem[mp] == 0) { ip = jumps[ip]; },
            ']' => if (mem[mp] != 0) { ip = jumps[ip]; },
            else => {},
        }
        ip += 1;
    }
    print("final #steps:{d}\n",.{step});
}

var jumps : [prog.len]usize = undefined;

fn precalculate_jumps() void {
    var last : usize = 0;
    for (0..prog.len) |i| {
        switch(prog[i]) {
            '[' => { jumps[i] = last; last = i; },
            ']' => {
                const saved_last = jumps[last];
                jumps[i] = last;
                jumps[last] = i;
                last = saved_last;
            },
            else => {
                jumps[i] = 0;
            }
        }
    }
}

// fn skip_right(ip0: usize) usize {
//     var ip = ip0;
//     var nest : usize = 0;
//     var c = prog[ip];
//     while (nest>0 or c != ']') {
//         if (ip > prog.len) break;
//         if (c == '[') nest += 1;
//         if (c == ']') nest -= 1;
//         ip += 1;
//         c = prog[ip];
//     }
//     return ip;
// }

// fn skip_left(ip0: usize) usize {
//     var ip = ip0;
//     var nest : usize = 0;
//     var c = prog[ip];
//     while (nest>0 or c != '[') {
//         if (ip > prog.len) break;
//         if (c == ']') nest += 1;
//         if (c == '[') nest -= 1;
//         ip -= 1;
//         c = prog[ip];
//     }
//     return ip;
// }
