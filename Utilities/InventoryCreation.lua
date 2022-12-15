local inventory = {}
inventory.root = script


local function retrieve_file(file_name)
    local file = inventory.root[file_name]
    return (require(file) or nil)
end

local function add_item(file, player, amount, config)
    local item = file.model
    local attributes = file.attributes

    local item_clone = item:Clone()

    if file.can_stack then 
        local left_over = file.max_stack - amount
        item_clone:SetAttribute("amount", amount or 1)
        item_clone:SetAttribute("max_amount", file.max_stack)
    end
end

local function check_for_overlap(file, player, amount, config)
    for _, item in next, player.Backpack:GetChildren() then 
        if item.Name == file.name then
            local item_amount = item:GetAttribute("amount")
            local max = item:GetAttribute("max_amount")
            if (item_amount < max) and (item_amount and max_amount) then
                local fit_amount = max - item_amount
                if fit_amount >= amount and amount > 0 then
                    amount = 0
                    item:SetAttribute("amount", item_amount + fit_amount)
                elseif fit_amount < amount and amount > 0 then
                    amount -= fit_amount
                    item:SetAttribute("amount", item_amount + fit_amount)
                end
            end
        end
    end
    if amount > 0 then
        add_item(file, player, amount, config)
    end
end

function inventory.get_item(item_name)
    return retrieve_file(item_name)
end

function inventory.add_to_inventory(item, player, amount, config)
    local file = retrieve_file(item)
    if file then
        check_for_overlap(file, player, amount, config)
    end
end

return inventory