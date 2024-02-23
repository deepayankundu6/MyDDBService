require 'json'
require './ddb_services'

def my_ddb_service(event:, context:)
  begin
    table_name = ENV['table_name']
    payload = JSON.parse( event['body'] ) if event['body']
    path = event["path"]

    save_to_ddb(table_name, payload) if path.include? "save"
    payload = get_item_ddb(table_name, payload["year"], payload["id"]) if path.include? "getItem"
    payload = get_items_ddb(table_name, payload["year"]) if path.include? "items"
    payload = get_ddb_table_keys(table_name) if path.include? "getKeys"

    {
      statusCode: 200,
      body: {
        message: 'Executed Successfully',
        items: payload
      }.to_json
    }

  rescue => error
    puts "Some error occured while executing the lambda: #{error}"
    {
      statusCode: 500,
      body: {
        message: error.message
      }.to_json
    }
  end
end
