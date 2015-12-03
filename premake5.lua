workspace 'mpack'
  configurations {'debug', 'asan', 'ubsan', 'msan', 'coverage', 'release'}
  platforms {'x64', 'x32'}
  language 'C'
  location 'build'
  includedirs 'include'
  flags {'ExtraWarnings'}
  buildoptions {'-Wconversion', '-Wstrict-prototypes', '-pedantic'}

  filter 'platforms:x64'
    architecture 'x64'

  filter 'platforms:x32'
    architecture 'x32'

  filter {'configurations:debug or *san or coverage'}
    defines 'DEBUG'
    optimize 'Off'
    flags {'Symbols'}

  filter {'configurations:*san'}
    buildoptions {'-fno-omit-frame-pointer', '-fno-optimize-sibling-calls'}

  filter {'configurations:asan'}
    buildoptions {'-fsanitize=address'}
    linkoptions {'-fsanitize=address'}

  filter {'configurations:ubsan'}
    buildoptions {'-fsanitize=undefined', '-fno-sanitize-recover'}
    linkoptions {'-fsanitize=undefined'}

  filter {'configurations:msan'}
    buildoptions {'-fsanitize=memory', '-fsanitize-memory-track-origins'}
    linkoptions {'-fsanitize=memory'}

  filter {'configurations:release'}
    optimize 'Speed'
    flags {'FatalWarnings'}

  project 'mpack'
    kind 'StaticLib'
    buildoptions {'-ansi'}
    files {
      'src/*.c'
    }
    filter {'configurations:coverage'}
      buildoptions {'--coverage'}
      linkoptions {'--coverage'}

  project 'tap'
    kind 'StaticLib'
    buildoptions {
      '-std=gnu99', '-Wno-conversion', '-Wno-unused-parameter'
    }
    files {
      'test/deps/tap/*.c'
    }

  project 'mpack-test'
    kind 'ConsoleApp'
    includedirs {'test/deps/tap'}
    files {
      'test/*.c'
    }
    buildoptions '-std=c99'
    links {'m', 'mpack', 'tap'}
    filter {'configurations:coverage'}
      linkoptions {'--coverage'}