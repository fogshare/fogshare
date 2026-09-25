package Fogshare::I18N::zh_tw;
#
# Fogshare - Traditional Chinese Lexicon (zh-tw)
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

use Mojo::Base 'Fogshare::I18N';

our %Lexicon = (

    # -------------------------------------------------------------------------
    # General & Base
    # -------------------------------------------------------------------------
    'Error'                                                    => '錯誤',
    'Page Not Found'                                           => '找不到頁面',
    'Not Found'                                                => '找不到資源',
    'The requested resource or sharing portal does not exist.' => '請求的資源或分享入口不存在。',
    'The requested resource was not found on this server.'     => '伺服器上找不到請求的資源。',
    'Go Back'                                                  => '返回上一頁',
    'Return Home'                                              => '返回首頁',
    'Toggle theme'                                             => '切換主題',
    'Scan to View on Mobile'                                   => '手機掃碼存取',
    'QR Code'                                                  => 'QR Code',

    # -------------------------------------------------------------------------
    # Directory Showcase (directory.html.ep)
    # -------------------------------------------------------------------------
    'Directory Index' => '目錄索引',
    'File Name'       => '檔案名稱',
    'Size'            => '大小',
    'Action'          => '操作',
    '.. (Parent)'     => '.. (上層目錄)',
    'Download'        => '下載',
    'Empty directory' => '目錄為空',

    # -------------------------------------------------------------------------
    # Expired Notice (expired.html.ep)
    # -------------------------------------------------------------------------
    '410 Gone'                                                      => '410 分享已過期',
    'This share link has expired or has been revoked by the owner.' => '此分享連結已失效或已被擁有者撤銷。',

    # -------------------------------------------------------------------------
    # Gate & Access Control (gate.html.ep)
    # -------------------------------------------------------------------------
    'Protected Access'                                             => '受保護的存取',
    'Protected Resource'                                           => '受保護的資源',
    'Please enter the passcode to access this share.'              => '請輸入通行密碼以存取此分享。',
    'Passcode'                                                     => '通行密碼 / 認證碼',
    'Unlock'                                                       => '解鎖存取',
    'Session remains valid for 24 hours'                           => '工作階段有效期為 24 小時',
    'Invalid passcode'                                             => '通行密碼錯誤',
    'Too many failed attempts. Temporarily locked for 15 minutes.' => '嘗試失敗次數過多，已暫時鎖定 15 分鐘。',

    # -------------------------------------------------------------------------
    # Gatekeeper / Burn-After-Reading Quota (gatekeeper.html.ep)
    # -------------------------------------------------------------------------
    'Ephemeral Access'                                              => '即看即焚存取',
    'Ephemeral Drop'                                                => '限時投遞',
    'Limited drop: [_1] access slots remaining.'                    => '限時分享：僅剩 [_1] 個存取名額。',
    'Remaining Slots: [_1]'                                         => '剩餘名額：[_1]',
    'Click below to claim an access slot and bind to this session.' => '點擊下方按鈕以佔用 1 次名額並綁定至目前工作階段。',
    'Reveal Content'                                                => '顯示內容',

    # -------------------------------------------------------------------------
    # Authentication (login.html.ep)
    # -------------------------------------------------------------------------
    'Admin Login'                                       => '管理員登入',
    'Authenticate with your administrator credentials.' => '請使用管理員憑據登入。',
    'Username'                                          => '使用者名稱',
    'Password'                                          => '密碼',
    'Sign In'                                           => '登入',
    'Invalid username or password'                      => '使用者名稱或密碼無效',
    'Logged out successfully.'                          => '已成功登出。',

    # -------------------------------------------------------------------------
    # Showcase Page (showcase.html.ep)
    # -------------------------------------------------------------------------
    'Preview not available for this file type' => '此檔案類型暫不支援直接預覽',
    'Direct Download'                          => '直接下載',

    # -------------------------------------------------------------------------
    # User Manager (users.html.ep & Controller/Users.pm)
    # -------------------------------------------------------------------------
    'Account Manager'                                                             => '帳號管理',
    'Admin Settings'                                                              => '管理員設定',
    'Manage administrator credentials for this node.'                             => '管理此節點的管理員帳號憑據。',
    'Edit'                                                                        => '編輯',
    'Delete'                                                                      => '刪除',
    'You'                                                                         => '目前使用者',
    'Delete user [_1]?'                                                           => '確定要刪除使用者 [_1] 嗎？',
    'New Password'                                                                => '新密碼',
    'Save / Update'                                                               => '儲存 / 更新',
    'Update [_1]'                                                                 => '更新 [_1]',
    '← Console'                                                                   => '← 控制台',
    'Logout'                                                                      => '登出',
    'Validation failed: Username must be >= 3 chars and password >= 6 chars.'     => '驗證失敗：使用者名稱需至少 3 字元，密碼需至少 6 字元。',
    'Account [_1] updated successfully.'                                          => '帳號 [_1] 儲存成功。',
    'Action prohibited: You cannot delete your currently logged-in account.'      => '操作禁止：無法刪除目前登入的帳號。',
    'Action prohibited: Cannot remove the last remaining administrative account.' => '操作禁止：無法移除系統唯一的管理員帳號。',
    'Account [_1] removed.'                                                       => '帳號 [_1] 已移除。',

    # -------------------------------------------------------------------------
    # Admin Dashboard & Navigation
    # -------------------------------------------------------------------------
    'Dashboard'                      => '管理主控台',
    'Manager'                        => '帳號管理',
    'Page [_1] of [_2] ([_3] total)' => '第 [_1] / [_2] 頁（共 [_3] 筆）',
    '← Prev'                         => '← 上一頁',
    'Next →'                         => '下一頁 →',
    'Share link is active:'          => '分享連結已生效：',
    'Passcode:'                      => '通行密碼：',
    'Copy Info'                      => '複製分享資訊',
    'Open ↗'                         => '開啟 ↗',
    'Files ([_1])'                   => '檔案庫 ([_1])',
    'Active ([_1])'                  => '生效中 ([_1])',
    'Expired ([_1])'                 => '已過期 ([_1])',
    'Trash ([_1])'                   => '垃圾桶 ([_1])',

    # -------------------------------------------------------------------------
    # Tab 1: Files
    # -------------------------------------------------------------------------
    'Drag & Drop files or folders here' => '拖曳檔案或資料夾至此',
    'browse files'                      => '瀏覽檔案',
    'browse folder'                     => '瀏覽資料夾',
    'Auto-extract if .zip archive'      => '若為 .zip 壓縮檔則自動解壓縮',
    'Preparing...'                      => '準備中...',
    'New Subfolder Name'                => '新子資料夾名稱',
    'New Root Folder Name'              => '新根資料夾名稱',
    'Create Folder'                     => '建立資料夾',
    'alphanumeric'                      => '英數字元及連字符',
    'repository'                        => '儲存庫',
    'Name'                              => '名稱',
    'Modified'                          => '修改時間',
    'Actions'                           => '操作',
    '[_1] active'                       => '[_1] 個活躍分享',
    'Share'                             => '建立分享',
    'Move'                              => '移動',
    'Copy'                              => '複製',
    'Rename'                            => '重新命名',
    'Delete this item permanently?'     => '確定要永久刪除此項目嗎？',

    # -------------------------------------------------------------------------
    # Tab 2: Active Shares
    # -------------------------------------------------------------------------
    'Active Shares ([_1])'             => '生效中的分享 ([_1])',
    'Cute Slug'                        => '短網址識別碼 (Slug)',
    'Target'                           => '目標路徑',
    'Auth'                             => '認證保護',
    'TTL Remaining'                    => '剩餘有效時間',
    'Views / Quota'                    => '存取次數 / 配額',
    'Pronounce'                        => '語音發音朗讀',
    'Click to copy pwd'                => '點擊複製密碼',
    'Public'                           => '公開存取',
    'Never'                            => '永久有效',
    '[_1] slots'                       => '[_1] 個名額',
    '[_1] ago'                         => '[_1] 前',
    'Move this active share to trash?' => '確定將此生效中的分享移至垃圾桶嗎？',

    # -------------------------------------------------------------------------
    # Tab 3: Expired Shares
    # -------------------------------------------------------------------------
    'Expired Shares ([_1])'                  => '已過期的分享 ([_1])',
    'Move Selected to Trash'                 => '將選取項目移至垃圾桶',
    'Move selected expired shares to trash?' => '確定將所選的過期分享移至垃圾桶嗎？',
    'Reason / Expired At'                    => '過期原因 / 到期時間',
    'Quota Exhausted'                        => '存取配額已耗盡',
    'Revoked'                                => '已手動撤銷',
    'Renew & Edit'                           => '續期並編輯',
    'To Trash'                               => '移至垃圾桶',
    'Move share [_1] to trash?'              => '確定將分享 [_1] 移至垃圾桶嗎？',
    'No expired shares'                      => '暫無過期分享',

    # -------------------------------------------------------------------------
    # Tab 4: Trash
    # -------------------------------------------------------------------------
    'Trash'                                                                 => '垃圾桶',
    'Empty Trash'                                                           => '清空垃圾桶',
    'WARNING: Permanently purge all items in trash? This cannot be undone.' => '警告：確定要徹底清除垃圾桶內的所有項目嗎？此操作無法還原。',
    'Original Lifespan'                                                     => '原始有效期限',
    'Config: [_1][_2]'                                                      => '設定：[_1][_2]',
    'Permanent'                                                             => '永久',
    'Restore'                                                               => '還原分享',
    'Purge'                                                                 => '徹底刪除',
    'Purge this config permanently?'                                        => '確定要永久銷毀此分享設定嗎？',
    'Trash is empty'                                                        => '垃圾桶是空的',

    # -------------------------------------------------------------------------
    # Flash Notifications & Controller Error Messages
    # -------------------------------------------------------------------------
    'Share [_1] moved to Trash.'                                                           => '分享 [_1] 已移入垃圾桶。',
    'Share [_1] purged permanently.'                                                       => '分享 [_1] 已徹底刪除。',
    'Moved [_1] selected share(s) to Trash.'                                               => '已將 [_1] 個選取的分享移入垃圾桶。',
    'Moved [_1] expired shares to Trash.'                                                  => '已將 [_1] 個過期分享移入垃圾桶。',
    'Purged [_1] items permanently from Trash.'                                            => '已從垃圾桶徹底清除 [_1] 項記錄。',
    'Renamed to [_1] successfully.'                                                        => '成功重新命名為 [_1]。',
    'Moved [_1] successfully.'                                                             => '成功移動 [_1]。',
    'Copied [_1] successfully.'                                                            => '成功複製 [_1]。',
    'Directory [_1] deleted permanently.'                                                  => '目錄 [_1] 已徹底刪除。',
    'File [_1] deleted permanently.'                                                       => '檔案 [_1] 已徹底刪除。',
    'The slug [_1] is a reserved system keyword.'                                          => '短網址 [_1] 是系統保留關鍵字。',
    'Share config [_1] not found anywhere.'                                                => '找不到分享設定 [_1]。',
    'Invalid JSON payload for [_1].'                                                       => '分享 [_1] 的中繼資料 JSON 無效。',
    'Target [_1] missing on disk. Cleaned.'                                                => '目標路徑 [_1] 在磁碟上不存在，已清理。',
    'Modification prohibited: Resource actively occupied by [_1]. Revoke the share first.' => '禁止修改：資源目前正被 [_1] 佔用，請先撤銷對應分享。',
    'Move prohibited: Resource actively occupied by [_1]. Revoke share first.'             => '禁止移動：資源目前正被 [_1] 佔用，請先撤銷對應分享。',
    'Deletion prohibited: Resource actively occupied by [_1]. Revoke the share first.'     => '禁止刪除：資源目前正被 [_1] 佔用，請先撤銷對應分享。',
    'Move failed: Target entity [_1] already exists in destination.'                       => '移動失敗：目標位置已存在同名實體 [_1]。',
    'Copy failed: Target entity [_1] already exists in destination.'                       => '複製失敗：目標位置已存在同名實體 [_1]。',
    'Upload rejected: [_1]'                                                                => '上傳被拒絕：[_1]',
    'Invalid folder name.'                                                                 => '資料夾名稱無效。',
    'Security Alert: CSRF token validation failed. Action rejected.'                       => '安全性攔截：CSRF Token 驗證失敗，操作已拒絕。',
    'Security Alert: Directory traversal detected.'                                        => '安全性攔截：偵測到目錄周遊越權操作。',
    'Security Alert: Access to hidden or system files is strictly restricted.'             => '安全性攔截：嚴禁存取系統隱藏檔案或中繼資料。',
    'Security Alert: Unauthorized deletion path.'                                          => '安全性攔截：未授權的非法刪除路徑。',
    'Move failed: Invalid source or destination path.'                                     => '移動失敗：來源路徑或目標路徑無效。',
    'Move failed: Cannot move a directory into its own subdirectory.'                      => '移動失敗：無法將母目錄移動至自身的子目錄中。',
    'Copy failed: Invalid source or destination path.'                                     => '複製失敗：來源路徑或目標路徑無效。',

    # -------------------------------------------------------------------------
    # Guest & Delivery Handlers (新增補充)
    # -------------------------------------------------------------------------
    'Internal Server Error'                                             => '內部伺服器錯誤',
    'Corrupted share metadata configuration.'                           => '分享中繼資料損毀。',
    'Forbidden'                                                         => '存取受限',
    'Automated access detected.'                                        => '偵測到自動化機器人或爬蟲存取。',
    'Too Many Requests'                                                 => '請求過於頻繁',
    'Too many verification attempts. Please wait.'                      => '驗證嘗試次數過多，請稍後再試。',
    'Unauthorized'                                                      => '未經授權',
    'Reserved endpoint'                                                 => '系統保留端點',
    'Target Missing'                                                    => '資源不存在',
    'The underlying file or directory has been removed from storage.'   => '底層對應的檔案或資料夾已從儲存空間中移除。',
    'Target [_1] does not exist.'                                       => '目標資源 [_1] 不存在。',
    'Directory traversal or unauthorized path access detected.'         => '偵測到目錄周遊或未經授權的路徑存取。',
    'Access Denied'                                                     => '存取被拒',
    'Access to hidden files or system metadata is strictly prohibited.' => '嚴禁存取隱藏檔案或系統中繼資料。',
    'Library Not Found'                                                 => '找不到共用程式庫',
    'Virtual shared library [_1] does not exist in libs/.'              => '虛擬共用程式庫 [_1] 不存在於 libs/ 目錄中。',

    # -------------------------------------------------------------------------
    # Dialogs & Form Labels
    # -------------------------------------------------------------------------
    'New Share Link'                                           => '建立新分享連結',
    'Lifespan (0 = Permanent)'                                 => '有效期限（0 為永久有效）',
    'Max Access Slots (0 = Unlimited / No Burn)'               => '最大存取次數（0 為不限制 / 非即看即焚）',
    'Custom Cute Slug (Optional)'                              => '自訂識別碼（選填）',
    'Access Password (Plain text, optional)'                   => '存取密碼（明文，留空則公開）',
    'Note (Shown on showcase page)'                            => '備註說明（顯示於分享首頁）',
    'Cancel'                                                   => '取消',
    'Create'                                                   => '立即建立',
    'Edit / Restore Share'                                     => '編輯 / 還原分享',
    'Target (Change file or directory to switch version)'      => '目標路徑（切換檔案或資料夾可直接替換版本）',
    'Type to search paths...'                                  => '輸入文字以搜尋路徑...',
    'New Lifespan (0 = Permanent)'                             => '新有效期限（0 為永久有效）',
    'Max Access Slots (0 = Unlimited)'                         => '最大存取名額（0 為不限制）',
    'Password (Leave empty to keep, type __CLEAR__ to remove)' => '密碼（留空保持原樣，輸入 __CLEAR__ 則清除）',
    'Save & Activate'                                          => '儲存並生效',
    'Confirm'                                                  => '確認提交',
    'Move Resource'                                            => '移動資源',
    'Copy Resource'                                            => '複製資源',
    'Destination Directory (Empty for root level)'             => '目的地資料夾（留空代表根目錄）',
    'Type to search folders...'                                => '輸入文字以搜尋資料夾...',
    'Confirm Move'                                             => '確認移動',
    'Confirm Copy'                                             => '確認複製',
    'Root directory'                                           => '根目錄',
    'Gen'                                                      => '產生',
    'Leave empty to keep intact'                               => '留空保持不變',
    'Note'                                                     => '備註說明',
    'e.g. Project assets download'                             => '例如：專案資源下載',
    'Leave empty for public access'                            => '留空代表公開存取',
    'New Name'                                                 => '新名稱',

    # -------------------------------------------------------------------------
    # Time Units & Countdown
    # -------------------------------------------------------------------------
    'Seconds' => '秒',
    'Minutes' => '分鐘',
    'Hours'   => '小時',
    'Days'    => '天',
    'Weeks'   => '週',
    'Months'  => '個月',
    'Years'   => '年',
    's left'  => '秒後到期',
    'm left'  => '分鐘後到期',
    'h left'  => '小時後到期',
    'd left'  => '天後到期',
    'Expired' => '已過期',

    # -------------------------------------------------------------------------
    # Client-Side JavaScript Strings
    # -------------------------------------------------------------------------
    'Copied link: [_1]'                     => '已複製連結：[_1]',
    'Copy manually:'                        => '請手動複製：',
    'Uploading [_1] file(s)... ([_2]%)'     => '正在上傳 [_1] 個檔案... ([_2]%)',
    'Upload failed: '                       => '上傳失敗：',
    'Network error occurred during upload.' => '上傳過程中發生網路錯誤。',

    # -------------------------------------------------------------------------
    # Default Public Portal
    # -------------------------------------------------------------------------
    'File Sharing Node'                        => '檔案分享節點',
    'Private sharing portal is active.'        => '私有分享節點運作正常。',
    'Direct access requires a dedicated link.' => '存取檔案需持有專屬分享連結。',
);

1;
