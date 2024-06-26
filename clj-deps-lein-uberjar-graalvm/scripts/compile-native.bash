#!/usr/bin/env bash

set -eou pipefail

set -x

main() {
  local -r jar_file="${1:-"./target/example-standalone.jar"}"
  local -r output_file="${2:-"./target/example-standalone"}"

  gu install native-image

  args=(
    # Native Image options
    # https://www.graalvm.org/22.0/reference-manual/native-image/Options

    "-jar" "${jar_file}"
    "-o" "${output_file}"

    # a comma-separated list of packages and classes (and implicitly all of their
    # superclasses) that are initialized during the image build. An empty string
    # designates all packages
#    "--initialize-at-build-time"

    # Instead of --initialize-at-build-time, use the following flag to initialize at build time
    "--features=clj_easy.graal_build_time.InitClojureClasses"

    # report the usage of unsupported methods and fields at runtime when they are
    # accessed the first time, instead of an error during an image building
#    "--report-unsupported-elements-at-runtime"

    #  don't reuse the compilation daemon across multiple native image builds
    "--no-server"

    # print stacktrace of underlying exception
    "-H:+ReportExceptionStackTraces"

    # enable verbose output
    "--verbose"

    # build a standalone image or report a failure
    "--no-fallback"

    # provide java.lang.Terminator exit handlers for executable images.
    "--install-exit-handlers"

    # show native toolchain information and image’s build settings.
    "--native-image-info"

    # Set optimisation setting
    #  b - optimize for fastest build time, 0 - no optimizations, 1 - basic optimizations
    #  2 - aggressive optimizations, 3 - all optimizations for best performance
    "-O1"
  )
  native-image "${args[@]}"
}

main "$@"
