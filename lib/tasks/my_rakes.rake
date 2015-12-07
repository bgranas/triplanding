  desc "Import countries." 
  task :import_countries => :environment do
    File.open("Countries.txt", "r").each do |line|
      name, country_iso_2, region, sub_region = line.strip.split("\t")
      c = Country.new(:name => name, :country_iso_2 => country_iso_2, :region => region, :sub_region => sub_region)
      c.save
    end
  end