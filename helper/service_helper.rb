require 'json'

def json_result(status, code, message, data = {})
  {
      status: status,
      payload: {
          code: code,
          message: message,
          data: data.to_json
      }
  }.to_json
end