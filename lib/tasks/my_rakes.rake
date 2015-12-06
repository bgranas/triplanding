  desc "Import countries." 
  task :import_countries => :environment do
    File.open("Countries.txt", "r").each do |line|
      name, region, sub_region = line.strip.split("\t")
      c = Country.new(:name => name, :region => region, :sub_region => sub_region)
      c.save
    end
  end