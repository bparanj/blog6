
## Using Dynamodb

Create docker-compose.yml file in the Rails project root:

```yml
version: "3.8"

services:
  localstack:
    container_name: "${LOCALSTACK_DOCKER_NAME-localstack_main}"
    image: localstack/localstack
    network_mode: bridge
    ports:
      - "127.0.0.1:53:53"
      - "127.0.0.1:53:53/udp"
      - "127.0.0.1:443:443"
      - "127.0.0.1:4566:4566"
      - "127.0.0.1:4571:4571"
    environment:
      - SERVICES=${SERVICES- }
      - DEBUG=${DEBUG- }
      - DATA_DIR=${DATA_DIR- }
      - LAMBDA_EXECUTOR=${LAMBDA_EXECUTOR- }
      - LOCALSTACK_API_KEY=${LOCALSTACK_API_KEY- }
      - KINESIS_ERROR_PROBABILITY=${KINESIS_ERROR_PROBABILITY- }
      - DOCKER_HOST=unix:///var/run/docker.sock
      - HOST_TMP_FOLDER="${TMPDIR:-/tmp}/localstack"
    volumes:
      - "${TMPDIR:-/tmp}/localstack:/tmp/localstack"
      - "/var/run/docker.sock:/var/run/docker.sock"
```

Run:

```
docker-compose up
```

Configure dynamoid gem by creating dynamoid in config/initializers folder:

```ruby
require "dynamoid"

Dynamoid.configure do |config|
  # Local DDB endpoint:
  config.endpoint = "http://localhost:4566"

  # Fake AWS credentials for local development purposes:
  config.access_key = "abc"
  config.secret_key = "xyz"
  config.region = "localhost"

  # Do not add prefixes to table names. By default dynamoid uses `dynamoid_#{application_name}_#{environment}` prefix:
  config.namespace = nil

  # Tells Dynamoid to use exponential backoff for batch operations (BatchGetItem, BatchPutItem)
  config.backoff = { exponential: { base_backoff: 0.2.seconds, ceiling: 10 } }

  # Do not add timestamps (created_at, updated_at) fields by default
  config.timestamps = false

  # Store datetimes as ISO-8601 strings by default. Otherwise UNIX timestamps will be used.
  config.store_datetime_as_string = true
end

```

Create a persistence class in app/models folder:

```ruby
class FlashCard
  include Dynamoid::Document

  table(name: "flashcards", key: :user_id)

  range :list_id, :string 

  field :name, :string
  field :created_at, :datetime, default: -> { Time.now } 
end
```

In the console, create the table and records:

```
 FlashCard.create(name: 'Datastructures', user_id: 1, list_id: 5)
[Aws::DynamoDB::Client 200 0.038681 0 retries] put_item(table_name:"flashcards",item:{"user_id"=>{s:"1"},"list_id"=>{s:"5"},"name"=>{s:"Datastructures"},"created_at"=>{s:"2021-09-23T13:20:41+00:00"}},expected:{"user_id"=>{exists:false},"list_id"=>{exists:false}})  

(39.93 ms) PUT ITEM - ["flashcards", {:user_id=>"1", :list_id=>"5", :name=>"Datastructures", :created_at=>"2021-09-23T13:20:41+00:00"}, {}]
```