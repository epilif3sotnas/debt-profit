const std = @import("std");

pub fn build(b: *std.Build) void {
    const build_options = buildOptions(b);
    const project_properties = projectProperties(b);

    const exe = executable(b, build_options, project_properties);
    dependencies(b, exe);
    runCmd(b, exe);

    const run_exe_unit_tests = testExecutable(b, build_options, project_properties);
    testRunCmd(b, run_exe_unit_tests);
}

const BuildOptions = struct {
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
};

fn buildOptions(b: *std.Build) BuildOptions {
    return BuildOptions {
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    };
}

const ProjectProperties = struct {
    name: []const u8,
    root_source_file: ?std.Build.LazyPath,
};

fn projectProperties(b: *std.Build) ProjectProperties {
    return ProjectProperties {
        .name = "debt-profit",
        .root_source_file = b.path("src/main.zig"),
    };
}

fn executable(
    b: *std.Build,
    build_options: BuildOptions,
    project_properties: ProjectProperties,
) *std.Build.Step.Compile {
    return b.addExecutable(.{
        .name = project_properties.name,
        .root_source_file = project_properties.root_source_file,
        .target = build_options.target,
        .optimize = build_options.optimize,
    });
}

fn dependencies(b: *std.Build, exe: *std.Build.Step.Compile) void {
    const yazap = b.dependency("yazap", .{});
    exe.root_module.addImport("yazap", yazap.module("yazap"));

    b.installArtifact(exe);
}

fn runCmd(b: *std.Build, exe: *std.Build.Step.Compile) void {
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run Program");
    run_step.dependOn(&run_cmd.step);

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
}

fn testExecutable(
    b: *std.Build,
    build_options: BuildOptions,
    project_properties: ProjectProperties,
) *std.Build.Step.Compile {
    return b.addTest(.{
        .root_source_file = project_properties.root_source_file.?,
        .target = build_options.target,
        .optimize = build_options.optimize,
    });
}

fn testRunCmd(b: *std.Build, exe: *std.Build.Step.Compile) void {
    const run_exe_unit_tests = b.addRunArtifact(exe);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}