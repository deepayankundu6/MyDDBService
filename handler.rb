require 'json'
require 'aws-sdk-dynamodb'

def save_to_ddb(event:, context:)
  {
    statusCode: 200,
    body: {
      message: 'Go Serverless v1.0! Your function executed successfully!',
      input: event
    }.to_json
  }
end
