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
        switch(op) {
            ',' => @panic("input"),
            '.' => print("{c}",.{mem[mp]}),
            '+' => mem[mp] +%= 1,
            '-' => mem[mp] -%= 1,
            '>' => mp += 1,
            '<' => mp -= 1,
            '[' => if (mem[mp] == 0) { ip = skip_right(ip+1); },
            ']' => if (mem[mp] != 0) { ip = skip_left(ip-1); },
            else => {},
        }
        ip += 1;
    }
    print("final #steps:{d}\n",.{step});
}

fn skip_right(ip0: usize) usize {
    var ip = ip0;
    var nest : usize = 0;
    var c = prog[ip];
    while (nest>0 or c != ']') {
        if (ip > prog.len) break;
        if (c == '[') nest += 1;
        if (c == ']') nest -= 1;
        ip += 1;
        c = prog[ip];
    }
    return ip;
}

fn skip_left(ip0: usize) usize {
    var ip = ip0;
    var nest : usize = 0;
    var c = prog[ip];
    while (nest>0 or c != '[') {
        if (ip > prog.len) break;
        if (c == ']') nest += 1;
        if (c == '[') nest -= 1;
        ip -= 1;
        c = prog[ip];
    }
    return ip;
}
