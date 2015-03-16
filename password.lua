password = {}

function password.numtocode(stage, totable, diffi)
	--totable:true/false, return result as table/string
	--stage to code
	local rawcode = {}
	local decimal = {}
	local final = {}
	local key = {1, 0, 1, 0, 1, 1, 0, 0, 1}
	if stage < 10 then
		decimal[1] = 0
		decimal[2] = stage
	else
		decimal[1] = string.sub(stage, 1, 1)
		decimal[2] = string.sub(stage, 2, 2)
	end
	rawcode[1] = {}
	rawcode[2] = {}
	rawcode[3] = {}
	
	rawcode[1] = binary(decimal[1])
	rawcode[2] = binary(decimal[2])
	
	local a
	local b
	
	table.insert(rawcode[3], diffi - 1)
	
	for a = 1, 2 do
		for b = 1, 4 do
			table.insert(rawcode[3], rawcode[a][b])
		end
	end
	
	--do xor with key
	for a = 1, 9 do
		if key[a] == rawcode[3][a] then
			table.insert(final, 0)
		else
			table.insert(final, 1)
		end
	end
	
	local result = ""
	for a = 1, 9 do
		result = result .. final[a]
	end
	
	if totable == true then
		return final
	else
		return result
	end
end

function password.codetonum(code, totable)
	--totable:true/false, return result as table/string
	
	--stage to code
	local rawcode = {}
	local tblcode = {}
	local final = {}
	local key = {1, 0, 1, 0, 1, 1, 0, 0, 1}
	
	--split code string to table
	for a = 1, 9 do
		table.insert(tblcode, string.sub(code, a, a))
	end
	
	--do xor with key
	for a = 1, 9 do
		if key[a] == tonumber(tblcode[a]) then
			table.insert(final, 0)
		else
			table.insert(final, 1)
		end
	end
	
	--translate binary into decimal

	local result = 0
	result = final[2] * 8 + final[3] * 4 + final[4] * 2 + final[5]
	result = result * 10 + final[6] * 8 + final[7] * 4 + final[8] * 2 + final[9]

	if result < 1 then
		return nil
	end
	
	if result > 44 then
		return nil
	end
	
	local diffi = final[1]
	game.diffi = final[1] + 1
	
	if totable == true then
		return final
	else
		return result
	end
end

function binary(decimal) --decimal to binary
	local a
	local tmparr
	local tmp
	local result
	
	result = {}
	
	tmparr = {}
	tmp = decimal
	for a = 1, 4 do
		tmparr[a] = tmp % 2
		tmp = math.floor(tmp/2)
	end
	
	for a = 1, 4 do
		if tmparr[a] == "" then
			tmparr[a] = 0
		end
	end
	
	for a = 4, 1, -1 do
		table.insert(result, tmparr[a])
	end
	return result
end