local T = wml.tag

function wesnoth.wml_actions.RSM_recruit(cfg)
    local gold = wesnoth.sides[wesnoth.current.side].gold
    local occupied = wesnoth.get_unit(wesnoth.current.event_context.x1, wesnoth.current.event_context.y1) ~= nil
    local list_string=cfg.list or ""
    local to_var = cfg.to or "chosen_unit"
    local recruit_list = {}
    for id in string.gmatch(list_string, "([^,]+)") do
        table.insert(recruit_list, id)
    end

    local list_item=T.row {
                        T.column {
                            vertical_grow = true,
                            horizontal_grow = true,

                            T.toggle_panel {
                                definition = "default",
                                return_value_id = "ok",

                                T.grid {
                                    T.row {
                                        T.column {
                                            grow_factor = 0,
                                            horizontal_grow = true,
                                            border = "all",
                                            border_size = 1,

                                            T.image {
                                                id = "unit_image",
                                                definition = "default",
                                                linked_group = "image"
                                            }
                                        },
                                        T.column {
                                            grow_factor = 1,
                                            horizontal_grow = true,

                                            T.grid {
                                                T.row {
                                                    T.column {
                                                        border = "all",
                                                        border_size = 5,
                                                        horizontal_alignment = "left",

                                                        T.label {
                                                            id = "unit_type",
                                                            definition = "default",
                                                            linked_group = "type"
                                                        }
                                                    }
                                                },
                                                T.row {
                                                    T.column {
                                                        horizontal_alignment = "left",

                                                        T.grid {
                                                            T.row {
                                                                grow_factor = 0,

                                                                -- Gold icon
                                                                T.column {
                                                                    border = "left,bottom",
                                                                    border_size = 5,
                                                                    horizontal_alignment = "left",

                                                                    T.image {
                                                                        id = "gold_icon",
                                                                        definition = "default",
                                                                        label = "themes/gold.png"
                                                                    }
                                                                },
                                                                T.column {
                                                                    border = "left,bottom,right",
                                                                    border_size = 5,
                                                                    horizontal_alignment = "left",

                                                                    T.label {
                                                                        id = "unit_cost",
                                                                        definition = "default"
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        },
                                        T.column {
                                            T.spacer { width = 25 }
                                        }
                                    }
                                }
                            }
                        }
                    }

    local list_definition=T.listbox {
                id = "siegeEngineRecruit",
                definition = "siegeEngineRecruit",

                T.list_definition {
                    list_item 
                }
            }
    

    local dialogDefinition = {
        T.tooltip { id = "tooltip" },
        T.helptip { id = "tooltip" },
        T.linked_group { id = "available_unit", fixed_width = true },
        T.grid {
            T.row {
                grow_factor = 1,

                T.column {
                    horizontal_grow = true,
                    vertical_grow = true,

                    T.grid {
                        T.row {
                            T.column {
                                grow_factor = 1,
                                border = "all",
                                border_size = 5,
                                horizontal_alignment = "left",

                                T.label {
                                    definition = "title",
                                    label =_ "Recruit Unit"
                                }
                            },
                            T.column {
                                border = "all",
                                border_size = 5,
                                horizontal_alignment = "left",

                                T.text_box {
                                    id = "filter_box",
                                    definition = "default",
                                    hint_text =_ "Search",
                                    hint_image = "icons/action/zoomdefault_25.png~FL(horiz)"
                                }
                            }
                        },
                        T.row {
                            T.column {
                                grow_factor = 0,
                                horizontal_grow = true,
                                vertical_grow = true,
                                border = "all",
                                border_size = 5,

                                T.unit_preview_pane {
                                    definition = "default",
                                    id = "recruit_details"

                                    --we are going to have to figure out how we populate this preview pane
                                }
                            },
                            T.column {
                                grow_factor = 1,
                                horizontal_grow = true,
                                vertical_alignment = "top",
                                border = "all",
                                border_size = 5,
                                list_definition
                            }
                        }
                    }
                }
            },
            T.row {
                grow_factor = 0,

                T.column {
                    grow_factor = 0,
                    horizontal_grow = true,

                    T.grid {
                        T.row {
                            grow_factor = 0,
                            T.column {
                                grow_factor = 1,
                                border = "all",
                                border_size = 5,
                                horizontal_alignment = "left",

                                T.button {
                                    id = "show_help",
                                    definition = "help"
                                }
                            },
                            T.column {
                                grow_factor = 0,
                                border = "all",
                                border_size = 5,
                                horizontal_alignment = "right",

                                T.button {
                                    id = "ok",
                                    definition = "default",
                                    label = _ "Recruit"
                                }
                            },
                            T.column {
                                grow_factor = 0,
                                border = "all",
                                border_size = 5,
                                horizontal_alignment = "right",

                                T.button {
                                    id = "cancel",
                                    definition = "default",
                                    label = _ "Cancel"
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    


    local picked = 1
    -- I need a list of units for this function to work
    local function preshow(dialog)
        local listDefinition=dialog["siegeEngineRecruit"]
        local units = {}
        local function renderList(list)
            for i,unit_id in ipairs(list) do
                local unit = wesnoth.unit_types[unit_id]
                if unit then
                    listDefinition[i].unit_image.label=unit.image
                    listDefinition[i].unit_type.label=unit.name
                    listDefinition[i].unit_cost.label=unit.cost
                    table.insert(units, unit)

                    if unit.cost > gold or occupied then
                        listDefinition[i].unit_image.label = unit.image .. "~GS()"
                        listDefinition[i].unit_type.enabled=false
                        listDefinition[i].unit_cost.enabled=false
                        listDefinition[i].gold_icon.label = "themes/gold.png~GS()"
                    else
                        listDefinition[i].unit_type.enabled=true
                        listDefinition[i].unit_cost.enabled=true
                        listDefinition[i].gold_icon.label="themes/gold.png"
                    end 
                end
            end
        end
        local function draw_unit()
            local tmp=wesnoth.create_unit { 
                type=units[listDefinition.selected_index].name,
                side=wesnoth.current_side
            }
            dialog.recruit_details.unit = tmp
            wesnoth.units.extract(tmp)
            picked = listDefinition.selected_index 
        end
        
        renderList(recruit_list)
        draw_unit()
        -- check if the initially selected unit should enable the ok button or not
        if occupied or units[listDefinition.selected_index].cost >= gold then
            dialog.ok.enabled = false
        else
            dialog.ok.enabled = true
        end
        
        -- event listeners
        listDefinition.on_modified = function()
            local idx = listDefinition.selected_index
            local ut = units[idx]
            dialog.ok.enabled = (ut.cost <= gold)
            draw_unit()
        end
        -- dialog.filter_box.on_modified = function()
        --     dialog.siegeEngineRecruit:clear()
        --     filter_text=dialog.filter_box.text:lower()

        --     local filtered_list={}
        --     for _, id in ipairs(recruit_list) do
        --         local ut = wesnoth.unit_types[id]
        --         if ut then
        --             local name = ut.name:lower()
        --             if name:find(filter_text, 1, true) then
        --                 table.insert(filtered_list, ut.name)
        --             end
        --         end
        --     end

        --     renderList(filtered_list)
        -- end
        
        dialog.show_help.on_button_click = function()
            gui.show_help("recruit")
        end
        dialog.cancel.on_button_click=function()
            picked=-1
        end
    end    
    
    
    gui.show_dialog(dialogDefinition,preshow)
    if picked >= 1 then
        wml.variables[to_var] = recruit_list[picked]
    else
        wml.variables[to_var] = ""
    end

end