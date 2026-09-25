package Fogshare::I18N::zh_cn;
#
# Fogshare - Simplified Chinese Lexicon (zh-cn)
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

use Mojo::Base 'Fogshare::I18N';

our %Lexicon = (

    # -------------------------------------------------------------------------
    # General & Base
    # -------------------------------------------------------------------------
    'Error'                                                    => '错误',
    'Page Not Found'                                           => '页面未找到',
    'Not Found'                                                => '未找到资源',
    'The requested resource or sharing portal does not exist.' => '请求的资源或分享入口不存在。',
    'The requested resource was not found on this server.'     => '在此服务器上未找到请求的资源。',
    'Go Back'                                                  => '返回上一页',
    'Return Home'                                              => '返回首页',
    'Toggle theme'                                             => '切换主题',
    'Scan to View on Mobile'                                   => '手机扫码访问',
    'QR Code'                                                  => '二维码',

    # -------------------------------------------------------------------------
    # Directory Showcase (directory.html.ep)
    # -------------------------------------------------------------------------
    'Directory Index' => '目录索引',
    'File Name'       => '文件名',
    'Size'            => '大小',
    'Action'          => '操作',
    '.. (Parent)'     => '.. (上级目录)',
    'Download'        => '下载',
    'Empty directory' => '空目录',

    # -------------------------------------------------------------------------
    # Expired Notice (expired.html.ep)
    # -------------------------------------------------------------------------
    '410 Gone'                                                      => '410 分享已失效',
    'This share link has expired or has been revoked by the owner.' => '此分享链接已过期或已被所有者撤销。',

    # -------------------------------------------------------------------------
    # Gate & Access Control (gate.html.ep)
    # -------------------------------------------------------------------------
    'Protected Access'                                             => '访问受限',
    'Protected Resource'                                           => '受保护的资源',
    'Please enter the passcode to access this share.'              => '请输入提取码以访问此分享。',
    'Passcode'                                                     => '提取码 / 口令',
    'Unlock'                                                       => '解锁访问',
    'Session remains valid for 24 hours'                           => '会话有效期为 24 小时',
    'Invalid passcode'                                             => '提取码不正确',
    'Too many failed attempts. Temporarily locked for 15 minutes.' => '尝试失败次数过多，已临时锁定 15 分钟。',

    # -------------------------------------------------------------------------
    # Gatekeeper / Burn-After-Reading Quota (gatekeeper.html.ep)
    # -------------------------------------------------------------------------
    'Ephemeral Access'                                              => '阅后即焚访问',
    'Ephemeral Drop'                                                => '临时投递',
    'Limited drop: [_1] access slots remaining.'                    => '临时分享：仅剩 [_1] 次访问名额。',
    'Remaining Slots: [_1]'                                         => '剩余访问名额：[_1]',
    'Click below to claim an access slot and bind to this session.' => '点击下方按钮消耗 1 次名额并绑定当前设备会话。',
    'Reveal Content'                                                => '查看内容',

    # -------------------------------------------------------------------------
    # Authentication (login.html.ep)
    # -------------------------------------------------------------------------
    'Admin Login'                                       => '管理员登录',
    'Authenticate with your administrator credentials.' => '请使用管理员凭据登录。',
    'Username'                                          => '用户名',
    'Password'                                          => '密码',
    'Sign In'                                           => '登录',
    'Invalid username or password'                      => '用户名或密码无效',
    'Logged out successfully.'                          => '已安全登出。',

    # -------------------------------------------------------------------------
    # Showcase Page (showcase.html.ep)
    # -------------------------------------------------------------------------
    'Preview not available for this file type' => '此文件类型暂不支持直接预览',
    'Direct Download'                          => '直接下载',

    # -------------------------------------------------------------------------
    # User Manager (users.html.ep & Controller/Users.pm)
    # -------------------------------------------------------------------------
    'Account Manager'                                                             => '账号管理',
    'Admin Settings'                                                              => '管理员设置',
    'Manage administrator credentials for this node.'                             => '管理当前节点的管理员账户凭据。',
    'Edit'                                                                        => '编辑',
    'Delete'                                                                      => '删除',
    'You'                                                                         => '当前用户',
    'Delete user [_1]?'                                                           => '确定删除用户 [_1] 吗？',
    'New Password'                                                                => '新密码',
    'Save / Update'                                                               => '保存 / 更新',
    'Update [_1]'                                                                 => '更新 [_1]',
    '← Console'                                                                   => '← 控制台',
    'Logout'                                                                      => '登出',
    'Validation failed: Username must be >= 3 chars and password >= 6 chars.'     => '验证失败：用户名至少 3 字符，密码至少 6 字符。',
    'Account [_1] updated successfully.'                                          => '账户 [_1] 保存成功。',
    'Action prohibited: You cannot delete your currently logged-in account.'      => '操作受限：无法删除当前已登录的账号。',
    'Action prohibited: Cannot remove the last remaining administrative account.' => '操作受限：无法删除系统仅存的最后一个管理员。',
    'Account [_1] removed.'                                                       => '账户 [_1] 已移除。',

    # -------------------------------------------------------------------------
    # Admin Dashboard & Navigation
    # -------------------------------------------------------------------------
    'Dashboard'                      => '管理控制台',
    'Manager'                        => '用户管理',
    'Page [_1] of [_2] ([_3] total)' => '第 [_1] / [_2] 页（共 [_3] 条）',
    '← Prev'                         => '← 上一页',
    'Next →'                         => '下一页 →',
    'Share link is active:'          => '分享外链已激活：',
    'Passcode:'                      => '访问口令：',
    'Copy Info'                      => '复制分享信息',
    'Open ↗'                         => '打开 ↗',
    'Files ([_1])'                   => '文件仓库 ([_1])',
    'Active ([_1])'                  => '生效中 ([_1])',
    'Expired ([_1])'                 => '已过期 ([_1])',
    'Trash ([_1])'                   => '回收站 ([_1])',

    # -------------------------------------------------------------------------
    # Tab 1: Files
    # -------------------------------------------------------------------------
    'Drag & Drop files or folders here' => '拖拽文件或文件夹到此处',
    'browse files'                      => '浏览文件',
    'browse folder'                     => '浏览文件夹',
    'Auto-extract if .zip archive'      => '若是 .zip 压缩包则自动解压',
    'Preparing...'                      => '准备中...',
    'New Subfolder Name'                => '新建子文件夹名称',
    'New Root Folder Name'              => '新建根目录文件夹名称',
    'Create Folder'                     => '创建文件夹',
    'alphanumeric'                      => '支持字母、数字及横杠',
    'repository'                        => '存储根库',
    'Name'                              => '名称',
    'Modified'                          => '修改时间',
    'Actions'                           => '操作',
    '[_1] active'                       => '[_1] 个生效中外链',
    'Share'                             => '创建分享',
    'Move'                              => '移动',
    'Copy'                              => '复制',
    'Rename'                            => '重命名',
    'Delete this item permanently?'     => '确定永久删除该资源吗？',

    # -------------------------------------------------------------------------
    # Tab 2: Active Shares
    # -------------------------------------------------------------------------
    'Active Shares ([_1])'             => '生效中的分享 ([_1])',
    'Cute Slug'                        => '易读短链 (Slug)',
    'Target'                           => '指向目标',
    'Auth'                             => '权限保护',
    'TTL Remaining'                    => '剩余有效时间',
    'Views / Quota'                    => '访问量 / 阅后即焚配额',
    'Pronounce'                        => '单词发音朗读',
    'Click to copy pwd'                => '点击复制口令',
    'Public'                           => '公开访问',
    'Never'                            => '永久有效',
    '[_1] slots'                       => '[_1] 个名额',
    '[_1] ago'                         => '[_1] 前',
    'Move this active share to trash?' => '确定将此活跃分享移入回收站吗？',

    # -------------------------------------------------------------------------
    # Tab 3: Expired Shares
    # -------------------------------------------------------------------------
    'Expired Shares ([_1])'                  => '已失效分享 ([_1])',
    'Move Selected to Trash'                 => '移动选中项至回收站',
    'Move selected expired shares to trash?' => '确定将所选已过期分享移入回收站吗？',
    'Reason / Expired At'                    => '失效原因 / 到期时间',
    'Quota Exhausted'                        => '阅后即焚已耗尽',
    'Revoked'                                => '已主动撤回',
    'Renew & Edit'                           => '续期并编辑',
    'To Trash'                               => '移至回收站',
    'Move share [_1] to trash?'              => '确定将分享 [_1] 移至回收站吗？',
    'No expired shares'                      => '暂无失效分享',

    # -------------------------------------------------------------------------
    # Tab 4: Trash
    # -------------------------------------------------------------------------
    'Trash'                                                                 => '回收站',
    'Empty Trash'                                                           => '清空回收站',
    'WARNING: Permanently purge all items in trash? This cannot be undone.' => '警告：彻底清空回收站内所有记录？此操作不可逆。',
    'Original Lifespan'                                                     => '原设定有效期',
    'Config: [_1][_2]'                                                      => '配置：[_1][_2]',
    'Permanent'                                                             => '永久',
    'Restore'                                                               => '恢复分享',
    'Purge'                                                                 => '彻底粉碎',
    'Purge this config permanently?'                                        => '确定永久粉碎此分享记录吗？',
    'Trash is empty'                                                        => '回收站为空',

    # -------------------------------------------------------------------------
    # Flash Notifications & Controller Error Messages
    # -------------------------------------------------------------------------
    'Share [_1] moved to Trash.'                                                           => '分享 [_1] 已移入回收站。',
    'Share [_1] purged permanently.'                                                       => '分享 [_1] 已彻底删除。',
    'Moved [_1] selected share(s) to Trash.'                                               => '已将 [_1] 个选中的分享移入回收站。',
    'Moved [_1] expired shares to Trash.'                                                  => '已将 [_1] 个过期分享移入回收站。',
    'Purged [_1] items permanently from Trash.'                                            => '已从回收站彻底粉碎 [_1] 项记录。',
    'Renamed to [_1] successfully.'                                                        => '成功重命名为 [_1]。',
    'Moved [_1] successfully.'                                                             => '成功移动 [_1]。',
    'Copied [_1] successfully.'                                                            => '成功复制 [_1]。',
    'Directory [_1] deleted permanently.'                                                  => '目录 [_1] 已彻底删除。',
    'File [_1] deleted permanently.'                                                       => '文件 [_1] 已彻底删除。',
    'The slug [_1] is a reserved system keyword.'                                          => '短链 [_1] 是系统保留关键字。',
    'Share config [_1] not found anywhere.'                                                => '未找到分享配置 [_1]。',
    'Invalid JSON payload for [_1].'                                                       => '分享 [_1] 的元数据 JSON 无效。',
    'Target [_1] missing on disk. Cleaned.'                                                => '目标路径 [_1] 在磁盘上不存在，已清理。',
    'Modification prohibited: Resource actively occupied by [_1]. Revoke the share first.' => '禁止修改：资源当前正被 [_1] 占用，请先撤销对应外链。',
    'Move prohibited: Resource actively occupied by [_1]. Revoke share first.'             => '禁止移动：资源当前正被 [_1] 占用，请先撤销对应外链。',
    'Deletion prohibited: Resource actively occupied by [_1]. Revoke the share first.'     => '禁止删除：资源当前正被 [_1] 占用，请先撤销对应外链。',
    'Move failed: Target entity [_1] already exists in destination.'                       => '移动失败：目标位置已存在同名实体 [_1]。',
    'Copy failed: Target entity [_1] already exists in destination.'                       => '复制失败：目标位置已存在同名实体 [_1]。',
    'Upload rejected: [_1]'                                                                => '上传被拒绝：[_1]',
    'Invalid folder name.'                                                                 => '文件夹名称无效。',
    'Security Alert: CSRF token validation failed. Action rejected.'                       => '安全拦截：CSRF Token 验证失败，操作已拒绝。',
    'Security Alert: Directory traversal detected.'                                        => '安全拦截：检测到目录穿越越权攻击。',
    'Security Alert: Access to hidden or system files is strictly restricted.'             => '安全拦截：严禁访问系统隐藏文件或元数据。',
    'Security Alert: Unauthorized deletion path.'                                          => '安全拦截：未授权的非法删除路径。',
    'Move failed: Invalid source or destination path.'                                     => '移动失败：源路径或目标路径无效。',
    'Move failed: Cannot move a directory into its own subdirectory.'                      => '移动失败：无法将父目录移动到自身的子目录中。',
    'Copy failed: Invalid source or destination path.'                                     => '复制失败：源路径或目标路径无效。',

    # -------------------------------------------------------------------------
    # Guest & Delivery Handlers (新增补充)
    # -------------------------------------------------------------------------
    'Internal Server Error'                                             => '内部服务器错误',
    'Corrupted share metadata configuration.'                           => '分享元数据损坏。',
    'Forbidden'                                                         => '访问受限',
    'Automated access detected.'                                        => '检测到自动化脚本或爬虫访问。',
    'Too Many Requests'                                                 => '请求过于频繁',
    'Too many verification attempts. Please wait.'                      => '人机验证尝试次数过多，请稍候再试。',
    'Unauthorized'                                                      => '未获授权',
    'Reserved endpoint'                                                 => '保留系统接口',
    'Target Missing'                                                    => '资源不存在',
    'The underlying file or directory has been removed from storage.'   => '底层对应的文件或目录已从存储介质中移除。',
    'Target [_1] does not exist.'                                       => '目标资源 [_1] 不存在。',
    'Directory traversal or unauthorized path access detected.'         => '检测到目录穿越或未经授权的非法访问。',
    'Access Denied'                                                     => '拒绝访问',
    'Access to hidden files or system metadata is strictly prohibited.' => '严禁访问隐藏文件或系统元数据。',
    'Library Not Found'                                                 => '公共库未找到',
    'Virtual shared library [_1] does not exist in libs/.'              => '共享虚拟库 [_1] 不存在于 libs/ 目录中。',

    # -------------------------------------------------------------------------
    # Dialogs & Form Labels
    # -------------------------------------------------------------------------
    'New Share Link'                                           => '创建新外链',
    'Lifespan (0 = Permanent)'                                 => '有效期（0 为永久有效）',
    'Max Access Slots (0 = Unlimited / No Burn)'               => '最大访问次数（0 为不限制 / 非阅后即焚）',
    'Custom Cute Slug (Optional)'                              => '自定义易读短链（选填）',
    'Access Password (Plain text, optional)'                   => '访问口令（明文，留空为公开）',
    'Note (Shown on showcase page)'                            => '备注说明（展示在外链主页）',
    'Cancel'                                                   => '取消',
    'Create'                                                   => '立即创建',
    'Edit / Restore Share'                                     => '编辑 / 恢复分享',
    'Target (Change file or directory to switch version)'      => '指向目标（更换文件或目录可直接平滑升降级版本）',
    'Type to search paths...'                                  => '输入以模糊搜索路径...',
    'New Lifespan (0 = Permanent)'                             => '新有效期（0 为永久有效）',
    'Max Access Slots (0 = Unlimited)'                         => '最大访问名额（0 为不限制）',
    'Password (Leave empty to keep, type __CLEAR__ to remove)' => '访问口令（留空保持不变，填 __CLEAR__ 则移除口令）',
    'Save & Activate'                                          => '保存并激活',
    'Confirm'                                                  => '确认提交',
    'Move Resource'                                            => '移动资源',
    'Copy Resource'                                            => '复制资源',
    'Destination Directory (Empty for root level)'             => '目标目录路径（留空代表仓库根目录）',
    'Type to search folders...'                                => '输入以搜索目录...',
    'Confirm Move'                                             => '确认移动',
    'Confirm Copy'                                             => '确认复制',
    'Root directory'                                           => '根目录',
    'Gen'                                                      => '生成',
    'Leave empty to keep intact'                               => '留空保持不变',
    'Note'                                                     => '备注说明',
    'e.g. Project assets download'                             => '例如：项目资源下载',
    'Leave empty for public access'                            => '留空表示公开访问',
    'New Name'                                                 => '新名称',

    # -------------------------------------------------------------------------
    # Time Units & Countdown
    # -------------------------------------------------------------------------
    'Seconds' => '秒',
    'Minutes' => '分钟',
    'Hours'   => '小时',
    'Days'    => '天',
    'Weeks'   => '周',
    'Months'  => '月',
    'Years'   => '年',
    's left'  => '秒后到期',
    'm left'  => '分钟后到期',
    'h left'  => '小时后到期',
    'd left'  => '天后到期',
    'Expired' => '已过期',

    # -------------------------------------------------------------------------
    # Client-Side JavaScript Strings
    # -------------------------------------------------------------------------
    'Copied link: [_1]'                     => '已复制链接：[_1]',
    'Copy manually:'                        => '请手动复制：',
    'Uploading [_1] file(s)... ([_2]%)'     => '正在上传 [_1] 个文件... ([_2]%)',
    'Upload failed: '                       => '上传失败：',
    'Network error occurred during upload.' => '上传过程中发生网络错误。',

    # -------------------------------------------------------------------------
    # Default Public Portal
    # -------------------------------------------------------------------------
    'File Sharing Node'                        => '文件分享节点',
    'Private sharing portal is active.'        => '私有分享节点运行正常。',
    'Direct access requires a dedicated link.' => '访问文件需持有专属提取链接。',
);

1;
