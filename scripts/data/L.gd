class_name L

static func node_desc(t: Nodes.NodeType) -> String:
    return {
        Nodes.NodeType.SHOP: "Units can be sold here.",
        Nodes.NodeType.MINE: "Generate units at a fixed rate.",
        Nodes.NodeType.LAB: "Convert basic units into research points.",
        Nodes.NodeType.RESEARCH_CENTER: "Allows researching new technologies.",
        Nodes.NodeType.PROCESSOR: "Increase units value.",
        Nodes.NodeType.REFINERY: "Multiplies unit by fixed value.",
        Nodes.NodeType.TETHER: "Distributes inputs to multiple nodes.",
        Nodes.NodeType.DUPLICATOR: "Duplicates units.",
        Nodes.NodeType.SPEED: "Speeds up units.",

    }[t]
static func node_name(t: Nodes.NodeType) -> String:
    return {
        Nodes.NodeType.SHOP: "Shop",
        Nodes.NodeType.MINE: "Mine",
        Nodes.NodeType.LAB: "Lab",
        Nodes.NodeType.RESEARCH_CENTER: "Research Center",
        Nodes.NodeType.PROCESSOR: "Processor",
        Nodes.NodeType.REFINERY: "Refinery",
        Nodes.NodeType.TETHER: "Tether",
        Nodes.NodeType.DUPLICATOR: "Duplicator",
        Nodes.NodeType.SPEED: "Accelerator",
    }[t]
static func upgrade_name(t: Upgrades.UpgradeType) -> String:
    return {
        Upgrades.UpgradeType.SPEED: "Speed upgrade",
        Upgrades.UpgradeType.VALUE: "Value upgrade",
        Upgrades.UpgradeType.UNLOCK: "ERR",
        Upgrades.UpgradeType.RP_MARKET: "Research market",
    }[t]

static func upgrade_desc(t: Upgrades.UpgradeType) -> String:
    return {
        Upgrades.UpgradeType.SPEED: "Make it faster !",
        Upgrades.UpgradeType.VALUE: "More value !",
        Upgrades.UpgradeType.UNLOCK: "ERR",
        Upgrades.UpgradeType.RP_MARKET: "Sell your research points.",
    }[t]