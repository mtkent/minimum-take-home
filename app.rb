require 'sinatra'
require 'csv'
require 'pry'

class Emission
    def initialize(co2e, scope, category, activity)
        @co2e = co2e
        @scope = scope
        @category = category
        @activity = activity
    end

    def get_co2e
        @co2e
    end

    def get_scope
        @scope
    end

    def get_category
        @category
    end

    def get_activity
        @activity
    end
end

# putting everything in a global variable for simplicity in this take-home
$all_emissions = []
$emission_csv = CSV.read("CSV-Emission-Factors-and-Activity-Data-Emission-Factors.csv")

def get_business_travel_emissions
    business_travel_csv = CSV.read("CSV-Emission-Factors-and-Activity-Data-Air-Travel.csv")
    _headers = business_travel_csv.shift
    
    business_travel_csv.each do |csv_line|
        keys = csv_line.last(2)
        business_travel_key = keys.first + ", " + keys.last # special case for the two keys needed to look up
        emission = get_emission(csv_line, "Air Travel", business_travel_key, 2) 
        
        $all_emissions << emission
    end
end

def get_goods_and_services_emissions
    goods_and_services_csv = CSV.read("CSV-Emission-Factors-and-Activity-Data-Purchased-Goods-Services.csv")
    _headers = goods_and_services_csv.shift 

    goods_and_services_csv.each do |csv_line|
        goods_and_services_key = csv_line[2]
        emission = get_emission(csv_line, "Purchased Goods and Services", goods_and_services_key, 3)
        
        $all_emissions << emission
    end
end

def get_electricity_emissions
    electricity_csv =  CSV.read("CSV-Emission-Factors-and-Activity-Data-Electricity.csv")
    _headers = electricity_csv.shift 

    electricity_csv.each do |csv_line|
        electricity_key = csv_line[2]
        emission = get_emission(csv_line, "Electricity", electricity_key, 3)

        $all_emissions << emission
    end
end

def get_emission (csv_line, activity_name, lookup_key, csv_location)
    emission_data = $emission_csv.select {|array| array.first == activity_name }
    # The case matching for the keys don't seem to work with example data for the business travel, we're downcasing to avoid any issues
    emission_match = emission_data.select {|array| array[1].downcase == lookup_key.downcase}.first

    co2 = calculate_co2_emission(csv_line, csv_location, emission_match[3].to_f, activity_name) 
    scope = emission_match[4]
    category = emission_match[5]
    activity = emission_match[0]

    emission = Emission.new(co2, scope, category, activity) 
end

def calculate_co2_emission(csv_line, csv_location, emission_factor_co2_value, activity_name)
    activity_data = csv_line[csv_location].to_f
    case activity_name
    when "Air Travel"
        if csv_line[4] == 'miles'
            activity_data * 1.609 * emission_factor_co2_value # convert miles to kilometers
        else
            activity_data * emission_factor_co2_value # already in kilometers
        end
    when "Purchased Goods and Services"
        emission_factor_co2_value # no need to multiply, just get the amount
    else
        activity_data * emission_factor_co2_value
    end
end

get '/' do
# call all the methods to get the data
get_electricity_emissions
get_goods_and_services_emissions
get_business_travel_emissions

# send the data to the table on index.erb
@table_data = $all_emissions
  
erb :index
end