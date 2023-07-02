require 'json'
require 'aws-sdk-dynamodb'

def save_to_ddb(event:, context:)
  
  table_name = ENV['table_name']
  payload = JSON.parse( event['body'] )
  year = Time.new
  id = rand(0..1000000000)

  table_item = {
      year: year.year.to_s,
      unique_id: id.to_s,
      body: payload
  }
  
  ddb_service = Aws::DynamoDB::Client.new

  ddb_service.put_item(
    {
      table_name: table_name,
      item: table_item
    }
  )

  {
    statusCode: 200,
    body: {
      message: 'Saved Successfully',
      items: payload
    }.to_json
  }

end
