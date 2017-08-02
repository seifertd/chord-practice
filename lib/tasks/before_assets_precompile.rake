task :before_assets_precompile do
  system('. ~/.nvm/nvm.sh && npm install && npm run build')
end

Rake::Task['assets:precompile'].enhance ['before_assets_precompile']
