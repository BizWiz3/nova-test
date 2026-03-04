local Nova = require("@pesde/nova")

local app = Nova.new(8080)

app:listen(function()  
    print("Nova is running on port 8080")
end)