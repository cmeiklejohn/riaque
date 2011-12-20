guard 'rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$}) { "spec" }
  watch(%r{^lib/(.+)\.rb$})     { "spec" }
  watch('spec/spec_helper.rb')  { "spec" }
end


guard 'ctags-bundler' do
  watch(%r{^(app|lib|spec/support)/.*\.rb$})  { ["app", "lib", "spec/support"] }
  watch('Gemfile.lock')
end

guard 'yard' do
  watch(%r{app/.+\.rb})
  watch(%r{lib/.+\.rb})
  watch(%r{ext/.+\.c})
end
