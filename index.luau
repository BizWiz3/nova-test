local Nova = require("@pesde/nova")
local process = require("@lune/process")

local port = tonumber(process.env.PORT) or 8080
local app = Nova.new(port)

app:listen(function()  
    print("Nova is running on port " .. port)
end)