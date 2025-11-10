const std = @import("std");

pub fn build(b: *std.Build) void {
    const mode = b.standardReleaseOptions();
    const lib = b.addStaticLibrary(.{
        .name = "zig-telegram",
        .root_source_file = b.path("root.zig"),
        .optimize = mode,
    });
    b.installArtifact(lib);
}
