const std = @import("std");
const polygon_renderer = @import("polygon_renderer");

const Color = struct { r: u8, g: u8, b: u8 };

fn TGAFrameBuffer(comptime width: usize, comptime height: usize) type {
    return struct {
        const Self = @This();

        pixels: [width * height * 3]u8,

        fn init() Self {
            return Self{ .pixels = [_]u8{0} ** (width * height * 3) };
        }

        fn set(self: *Self, x: usize, raw_y: usize, color: Color) void {
            const y = height - raw_y;
            self.pixels[(y * width + x) * 3 + 0] = color.r;
            self.pixels[(y * width + x) * 3 + 1] = color.g;
            self.pixels[(y * width + x) * 3 + 2] = color.b;
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

pub fn main() !void {
    const width = 64;
    const height = 64;

    var tgaFrameBuffer = TGAFrameBuffer(width, height).init();

    const ax = 7;
    const ay = 3;

    const bx = 12;
    const by = 37;

    const cx = 62;
    const cy = 53;

    tgaFrameBuffer.set(ax, ay, white);
    tgaFrameBuffer.set(bx, by, white);
    tgaFrameBuffer.set(cx, cy, white);

    _ = try tgaFrameBuffer.save("test.tga");
}
