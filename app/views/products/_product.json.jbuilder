json.extract! product, :id, :title, :description, :product_code, :product_image, :user_id, :created_at, :updated_at
json.url product_url(product, format: :json)