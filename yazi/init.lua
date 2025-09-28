require("no-status"):setup()

-- https://github.com/yazi-rs/plugins/tree/main/git.yazi#advanced
th.git = th.git or {}
th.git.modified = ui.Style():fg("#70AEFF")
th.git.added = ui.Style():fg("#73BD79")
th.git.untracked = ui.Style():fg("#E88F89")
th.git.ignored = ui.Style():fg("#D69A6B")
th.git.deleted = ui.Style():fg("#6F737A")
th.git.updated = ui.Style():fg("#DE6A66")
require("git"):setup()
