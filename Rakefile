namespace :prototype do
  desc "Create a new single-page web app in prototypes/ based on empty template"
  task :new, [:name] do |t, args|
    raise 'Must provide new app name as prototype:new[name]' if !args.name
    mkdir "prototypes/#{args.name}"
    cp_r "prototypes/empty/coffeescripts/", "prototypes/#{args.name}/"
    cp "prototypes/empty/main.html", "prototypes/#{args.name}/main.html"
    cp "prototypes/empty/Makefile", "prototypes/#{args.name}/Makefile"
  end
end
