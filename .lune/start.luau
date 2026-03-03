local process = require("@lune/process")

local result = process.exec("pesde", { "run" }, { stdio = "inherit" })

if not result.ok then 
    print(result.stderr)
end