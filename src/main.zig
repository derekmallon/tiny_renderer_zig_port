const std = @import("std");
const polygon_renderer = @import("polygon_renderer");
var prng = std.Random.DefaultPrng.init(0);
const Color = struct { r: u8, g: u8, b: u8 };
//const rand = prng.random();
//const j = rand.intRangeLessThan(usize, 0, i);

fn TGAFrameBuffer(comptime width: usize, comptime height: usize) type {
    return struct {
        const Self = @This();

        pixels: [width * height * 3]u8,

        fn init() Self {
            return Self{ .pixels = [_]u8{0} ** (width * height * 3) };
        }

        fn set(self: *Self, x: usize, raw_y: usize, color: Color) void {
            std.debug.print("raw_y {d}\n", .{raw_y});
            const y = (height - 1) - raw_y;
            self.pixels[(y * width + x) * 3 + 0] = color.b;
            self.pixels[(y * width + x) * 3 + 1] = color.g;
            self.pixels[(y * width + x) * 3 + 2] = color.r;
        }

        fn save(self: *const Self, filePath: []const u8) !void {
            var tgaHeader = [_]u8{0} ** 18;
            tgaHeader[2] = 2;
            tgaHeader[12] = 255 & width;
            tgaHeader[13] = 255 & (width >> 8);
            tgaHeader[14] = 255 & height;
            tgaHeader[15] = 255 & (height >> 8);
            tgaHeader[16] = 24;
            tgaHeader[17] = 32;

            var file = try std.fs.cwd().createFile(filePath, .{});
            defer file.close();

            try file.writeAll(tgaHeader[0..]);
            try file.writeAll(self.pixels[0..]);
        }
    };
}

const white = Color{ .r = 255, .b = 255, .g = 255 };
const blue = Color{ .r = 0, .b = 255, .g = 0 };
const green = Color{ .r = 0, .b = 0, .g = 255 };
const red = Color{ .r = 255, .b = 0, .g = 0 };
const yellow = Color{ .r = 255, .b = 0, .g = 255 };

fn swap(comptime T: type, a: *T, b: *T) void {
    const tmp = a.*;
    a.* = b.*;
    b.* = tmp;
}

//fn line(ax: usize, ay: usize, bx: usize, by: usize, frameBuffer: anytype, color: Color) void {
//    var t: f32 = 0.0;
//    const dx: f32 = @floatFromInt(@as(i32, @intCast(bx)) - @as(i32, @intCast(ax)));
//    const dy: f32 = @floatFromInt(@as(i32, @intCast(by)) - @as(i32, @intCast(ay)));
//    while (t < 1.0) {
//        const x: usize = @intFromFloat(@round(@as(f32, @floatFromInt(ax)) + dx * t));
//        const y: usize = @intFromFloat(@round(@as(f32, @floatFromInt(ay)) + dy * t));
//        t += 0.02;
//        frameBuffer.set(x, y, color);
//    }
//}

//fn line(ax: usize, ay: usize, bx: usize, by: usize, frameBuffer: anytype, color: Color) void {
//    var x = ax;
//    while (x <= bx) {
//        const t: f32 = @as(f32, @floatFromInt(x - ax)) / @as(f32, @floatFromInt(bx - ax));
//        const y: usize = @intFromFloat(@round(@as(f32, @floatFromInt(ay)) + @as(f32, @floatFromInt(by - ay)) * t));
//        frameBuffer.set(x, y, color);
//        x += 1;
//    }
//}

fn line(_ax: usize, _ay: usize, _bx: usize, _by: usize, frameBuffer: anytype, color: Color) void {
    var ax = _ax;
    var ay = _ay;
    var bx = _bx;
    var by = _by;

    if (ax > bx) {
        swap(usize, &ax, &bx);
        swap(usize, &ay, &by);
    }
    var x = ax;
    while (x <= bx) {
        const t: f32 = @as(f32, @floatFromInt(x - ax)) / @as(f32, @floatFromInt(bx - ax));
        const y: usize = @intFromFloat(@round(@as(f32, @floatFromInt(ay)) + @as(f32, @floatFromInt(by - ay)) * t));
        frameBuffer.set(x, y, color);
        x += 1;
    }
}

//fn line(_ax: usize, _ay: usize, _bx: usize, _by: usize, frameBuffer: anytype, color: Color) void {
//    var ax: i32 = @intCast(_ax);
//    var ay: i32 = @intCast(_ay);
//    var bx: i32 = @intCast(_bx);
//    var by: i32 = @intCast(_by);
//
//    if (ax == bx and ay == by) {
//        frameBuffer.set(_ax, _ay, color);
//        return;
//    }
//
//    const steep = @abs(ax - bx) < @abs(ay - by);
//
//    if (steep) {
//        swap(i32, &ax, &ay);
//        swap(i32, &bx, &by);
//    }
//
//    if (ax > bx) {
//        swap(i32, &ax, &bx);
//        swap(i32, &ay, &by);
//    }
//    var x = ax;
//    var y: f32 = @floatFromInt(ay);
//    while (x <= bx) {
//
//        //const y: usize = @intFromFloat(@round(@as(f32, @floatFromInt(ay)) + @as(f32, @floatFromInt(by - ay)) * t));
//        if (steep) {
//            frameBuffer.set(@intFromFloat(y), @intCast(x), color);
//        } else {
//            frameBuffer.set(@intCast(x), @intFromFloat(y), color);
//        }
//        x += 1;
//        y += @as(f32, @floatFromInt(by - ay)) / @as(f32, @floatFromInt(bx - ax));
//    }
//}

//fn line(_ax: usize, _ay: usize, _bx: usize, _by: usize, frameBuffer: anytype, color: Color) void {
//    var ax: i32 = @intCast(_ax);
//    var ay: i32 = @intCast(_ay);
//    var bx: i32 = @intCast(_bx);
//    var by: i32 = @intCast(_by);
//
//    if (ax == bx and ay == by) {
//        frameBuffer.set(_ax, _ay, color);
//        return;
//    }
//
//    const steep = @abs(ax - bx) < @abs(ay - by);
//
//    if (steep) {
//        swap(i32, &ax, &ay);
//        swap(i32, &bx, &by);
//    }
//
//    if (ax > bx) {
//        swap(i32, &ax, &bx);
//        swap(i32, &ay, &by);
//    }
//    var x = ax;
//    var y: i32 = ay;
//    var errorF: f32 = 0.0;
//    while (x <= bx) {
//
//        //const y: usize = @intFromFloat(@round(@as(f32, @floatFromInt(ay)) + @as(f32, @floatFromInt(by - ay)) * t));
//        if (steep) {
//            frameBuffer.set(@intCast(y), @intCast(x), color);
//        } else {
//            frameBuffer.set(@intCast(x), @intCast(y), color);
//        }
//        errorF += @as(f32, @floatFromInt(by - ay)) / @as(f32, @floatFromInt(bx - ax));
//        if (errorF > 0.5) {
//            if (by > ay) {
//                y += 1;
//            } else {
//                y += -1;
//            }
//        }
//        x += 1;
//    }
//}

//fn line(_ax: usize, _ay: usize, _bx: usize, _by: usize, frameBuffer: anytype, color: Color) void {
//    var ax: i32 = @intCast(_ax);
//    var ay: i32 = @intCast(_ay);
//    var bx: i32 = @intCast(_bx);
//    var by: i32 = @intCast(_by);
//
//    if (ax == bx and ay == by) {
//        frameBuffer.set(_ax, _ay, color);
//        return;
//    }
//
//    const steep = @abs(ax - bx) < @abs(ay - by);
//
//    if (steep) {
//        swap(i32, &ax, &ay);
//        swap(i32, &bx, &by);
//    }
//
//    if (ax > bx) {
//        swap(i32, &ax, &bx);
//        swap(i32, &ay, &by);
//    }
//    var x = ax;
//    var y: i32 = ay;
//    var errorI: i32 = 0;
//    while (x <= bx) {
//        if (steep) {
//            frameBuffer.set(@intCast(y), @intCast(x), color);
//        } else {
//            frameBuffer.set(@intCast(x), @intCast(y), color);
//        }
//        errorI += 2 * @as(i32, @intCast(@abs(by - ay)));
//        if (errorI > bx - ax) {
//            if (by > ay) {
//                y += 1;
//            } else {
//                y += -1;
//            }
//            errorI -= 2 * (bx - ax);
//        }
//        x += 1;
//    }
//}

const Vertex = struct { x: f32, y: f32, z: f32, w: f32 };
const Triangle = struct { verts: [3]Vertex };

fn writeTillEndOfDelimiter(reader: *std.Io.Reader, writer: *std.Io.Writer, delimiter: u8) !void {
    _ = try reader.streamDelimiter(writer, delimiter);
    reader.toss(1);
    while (reader.peek(1)) |bytes| {
        if (bytes.len > 0 and bytes[0] != delimiter) {
            return;
        } else {
            _ = try reader.streamDelimiter(writer, delimiter);
            reader.toss(1);
        }
    } else |err| switch (err) {
        error.EndOfStream => return,
        else => return err,
    }
}

fn readObjFile(allocator: std.mem.Allocator) !std.array_list.Managed(Triangle) {
    const filename = "diablo3_pose.obj";
    var file = try std.fs.cwd().openFile(filename, .{ .mode = .read_only });
    defer file.close();
    var buffer: [1024]u8 = undefined;
    var file_reader = file.reader(&buffer);
    const reader: *std.Io.Reader = &file_reader.interface;
    var array_list_writer = std.Io.Writer.Allocating.init(allocator);
    defer array_list_writer.deinit();
    var float_writer = std.Io.Writer.Allocating.init(allocator);
    defer float_writer.deinit();
    var vertex_list = std.array_list.Managed(Vertex).init(allocator);
    defer vertex_list.deinit();
    var triangles = std.array_list.Managed(Triangle).init(allocator);

    while (reader.streamDelimiter(&array_list_writer.writer, '\n')) |_| {
        reader.toss(1);
        const objLine = array_list_writer.written();
        var readerObjLine = std.Io.Reader.fixed(objLine);
        if (objLine.len > 1) {
            if (objLine[0] == 'v' and objLine[1] == ' ') {
                var v: Vertex = undefined;

                try writeTillEndOfDelimiter(&readerObjLine, &float_writer.writer, ' ');
                float_writer.clearRetainingCapacity();

                try writeTillEndOfDelimiter(&readerObjLine, &float_writer.writer, ' ');
                v.x = try std.fmt.parseFloat(f32, float_writer.written());
                float_writer.clearRetainingCapacity();

                try writeTillEndOfDelimiter(&readerObjLine, &float_writer.writer, ' ');
                v.y = try std.fmt.parseFloat(f32, float_writer.written());
                float_writer.clearRetainingCapacity();

                _ = try readerObjLine.streamRemaining(&float_writer.writer);
                v.z = try std.fmt.parseFloat(f32, float_writer.written());
                float_writer.clearRetainingCapacity();

                std.debug.print("{d} {d} {d}\n", .{ v.x, v.y, v.z });
                try vertex_list.append(v);
            } else if (objLine[0] == 'f' and objLine[1] == ' ') {
                const trimmedLine = std.mem.trim(u8, objLine, "f ");
                var vertex_it = std.mem.splitScalar(u8, trimmedLine, ' ');
                var vertex = vertex_it.next();
                var index_counter: usize = 0;
                var triangle: Triangle = undefined;
                while (vertex != null) {
                    const vertex_string = vertex orelse "";
                    var component_it = std.mem.splitScalar(u8, vertex_string, '/');
                    const vertex_index_string = component_it.next() orelse "";
                    const vertex_index: usize = try std.fmt.parseInt(usize, vertex_index_string, 10);
                    triangle.verts[index_counter] = vertex_list.items[vertex_index - 1];
                    vertex = vertex_it.next();
                    index_counter += 1;
                }

                try triangles.append(triangle);
            }
        }
        array_list_writer.clearRetainingCapacity();
    } else |err| switch (err) {
        error.ReadFailed,
        error.WriteFailed,
        => |e| return e,
        else => {},
    }

    return triangles;
}

fn maxFloat(a: f32, b: f32) f32 {
    if (a > b) return a;
    return b;
}

pub fn main() !void {
    const width = 64;
    const height = 64;

    var tgaFrameBuffer = TGAFrameBuffer(width, height).init();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    const triangles = try readObjFile(allocator);
    defer triangles.deinit();

    for (triangles.items) |triangle| {
        for (triangle.verts, 0..) |_, i| {
            const vert_a_index = if (i == 0) 2 else i - 1;
            const vert_a = triangle.verts[vert_a_index];
            const vert_b = triangle.verts[i];
            const ax: usize = @intFromFloat(maxFloat(vert_a.x, 0.0) * width);
            const ay: usize = @intFromFloat(maxFloat(vert_a.y, 0.0) * height);
            const bx: usize = @intFromFloat(maxFloat(vert_b.x, 0.0) * width);
            const by: usize = @intFromFloat(maxFloat(vert_b.y, 0.0) * height);
            std.debug.print("{d}\n", .{ay});
            line(ax, ay, bx, by, &tgaFrameBuffer, red);
        }
    }

    _ = try tgaFrameBuffer.save("test.tga");
}
