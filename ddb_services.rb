require 'aws-sdk-dynamodb'

def save_to_ddb(table_name, body)
  puts "Saving the item into dynamo DB"
  begin
    year = Time.new
    id = rand(0..1000000000)
    ddb_client = Aws::DynamoDB::Client.new

    table_item = {
      table_name: table_name,
        item: {
          "#{ENV['table_pk']}":  year.year.to_s,
          "#{ENV['table_sk']}": id.to_s,
          body: body
        }
    }

    ddb_client.put_item(table_item)
  rescue => error
      puts "Error occured while saving the item in DDB: #{error}"
      raise error
  end
end

def get_item_ddb(table_name, item_pk, item_sk)
puts "Getting item with keys as #{item_pk}:#{item_sk} from the table."
  begin
    ddb_client = Aws::DynamoDB::Client.new

    table_item = {
      table_name: table_name,
      key: {
        "#{ENV['table_pk']}": "#{item_pk}",
        "#{ENV['table_sk']}": "#{item_sk}"
       }
    }
    response = ddb_client.get_item(table_item)
    response["item"]

  rescue => error
      puts "Error occured while getting item from DDB: #{error}"
      raise error
  end
end

def get_items_ddb(table_name, item_pk)
 puts "Getting items with key as #{item_pk} from the table."
  begin
    ddb_client = Aws::DynamoDB::Client.new

    table_item = {
      table_name: table_name,
      select: "ALL_ATTRIBUTES",
      scan_filter: {
        "#{ENV['table_pk']}": {
          attribute_value_list: ["#{item_pk}"],
          comparison_operator: "EQ"
        }
      }
    }

    response = ddb_client.scan(table_item)
    response["items"]

  rescue => error
      puts "Error occured while getting item from DDB: #{error}"
      raise error
  end
end

def get_ddb_table_keys(table_name)
  puts "Getting partition keys of the table."
  begin
    ddb_client = Aws::DynamoDB::Client.new

    table_item = {
      table_name: table_name,
      attributes_to_get: ["#{ENV['table_pk']}","#{ENV['table_sk']}" ]
      }

    response = ddb_client.scan(table_item)
    response["items"]

  rescue => error
      puts "Error occured while getting item from DDB: #{error}"
      raise error
  end
end
