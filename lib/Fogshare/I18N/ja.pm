package Fogshare::I18N::ja;
#
# Fogshare - Japanese Lexicon (ja)
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

use Mojo::Base 'Fogshare::I18N';

our %Lexicon = (

    # -------------------------------------------------------------------------
    # General & Base
    # -------------------------------------------------------------------------
    'Error'                                                    => 'エラー',
    'Page Not Found'                                           => 'ページが見つかりません',
    'Not Found'                                                => 'リソースが見つかりません',
    'The requested resource or sharing portal does not exist.' => '指定されたリソースまたは共有ポータルは存在しません。',
    'The requested resource was not found on this server.'     => '要求されたリソースはこのサーバー上に見つかりませんでした。',
    'Go Back'                                                  => '戻る',
    'Return Home'                                              => 'ホームに戻る',
    'Toggle theme'                                             => 'テーマを切り替え',
    'Scan to View on Mobile'                                   => 'モバイル端末でアクセス',
    'QR Code'                                                  => 'QRコード',

    # -------------------------------------------------------------------------
    # Directory Showcase (directory.html.ep)
    # -------------------------------------------------------------------------
    'Directory Index' => 'ディレクトリ一覧',
    'File Name'       => 'ファイル名',
    'Size'            => 'サイズ',
    'Action'          => '操作',
    '.. (Parent)'     => '.. (親ディレクトリ)',
    'Download'        => 'ダウンロード',
    'Empty directory' => '空のディレクトリ',

    # -------------------------------------------------------------------------
    # Expired Notice (expired.html.ep)
    # -------------------------------------------------------------------------
    '410 Gone'                                                      => '410 共有リンクの期限切れ',
    'This share link has expired or has been revoked by the owner.' => 'この共有リンクは有効期限が切れたか、所有者によって取り消されました。',

    # -------------------------------------------------------------------------
    # Gate & Access Control (gate.html.ep)
    # -------------------------------------------------------------------------
    'Protected Access'                                             => 'アクセス制限',
    'Protected Resource'                                           => '保護されたリソース',
    'Please enter the passcode to access this share.'              => 'この共有にアクセスするにはパスコードを入力してください。',
    'Passcode'                                                     => 'パスコード',
    'Unlock'                                                       => 'ロック解除',
    'Session remains valid for 24 hours'                           => 'セッションは 24 時間有効です',
    'Invalid passcode'                                             => 'パスコードが正しくありません',
    'Too many failed attempts. Temporarily locked for 15 minutes.' => '試行回数が上限を超えました。15 分間ロックされます。',

    # -------------------------------------------------------------------------
    # Gatekeeper / Burn-After-Reading Quota (gatekeeper.html.ep)
    # -------------------------------------------------------------------------
    'Ephemeral Access'                                              => '閲覧後破棄アクセス',
    'Ephemeral Drop'                                                => '一時共有',
    'Limited drop: [_1] access slots remaining.'                    => '限定公開: 残り [_1] 回のアクセス枠があります。',
    'Remaining Slots: [_1]'                                         => '残りアクセス可能枠: [_1]',
    'Click below to claim an access slot and bind to this session.' => '下のボタンをクリックしてアクセス枠を消費し、セッションにバインドします。',
    'Reveal Content'                                                => 'コンテンツを表示',

    # -------------------------------------------------------------------------
    # Authentication (login.html.ep)
    # -------------------------------------------------------------------------
    'Admin Login'                                       => '管理者ログイン',
    'Authenticate with your administrator credentials.' => '管理者アカウントでサインインしてください。',
    'Username'                                          => 'ユーザー名',
    'Password'                                          => 'パスワード',
    'Sign In'                                           => 'サインイン',
    'Invalid username or password'                      => 'ユーザー名またはパスワードが無効です',
    'Logged out successfully.'                          => '正常にログアウトしました。',

    # -------------------------------------------------------------------------
    # Showcase Page (showcase.html.ep)
    # -------------------------------------------------------------------------
    'Preview not available for this file type' => 'このファイル形式のプレビューには対応していません',
    'Direct Download'                          => '直接ダウンロード',

    # -------------------------------------------------------------------------
    # User Manager (users.html.ep & Controller/Users.pm)
    # -------------------------------------------------------------------------
    'Account Manager'                                                             => 'アカウント管理',
    'Admin Settings'                                                              => '管理者設定',
    'Manage administrator credentials for this node.'                             => 'このノードの管理者アカウントを管理します。',
    'Edit'                                                                        => '編集',
    'Delete'                                                                      => '削除',
    'You'                                                                         => '現在のユーザー',
    'Delete user [_1]?'                                                           => 'ユーザー [_1] を削除しますか？',
    'New Password'                                                                => '新しいパスワード',
    'Save / Update'                                                               => '保存 / 更新',
    'Update [_1]'                                                                 => '[_1] を更新',
    '← Console'                                                                   => '← 管理コンソール',
    'Logout'                                                                      => 'ログアウト',
    'Validation failed: Username must be >= 3 chars and password >= 6 chars.'     => '入力エラー: ユーザー名は 3 文字以上、パスワードは 6 文字以上必要です。',
    'Account [_1] updated successfully.'                                          => 'アカウント [_1] を更新しました。',
    'Action prohibited: You cannot delete your currently logged-in account.'      => '操作拒否: 現在ログイン中のアカウントを削除することはできません。',
    'Action prohibited: Cannot remove the last remaining administrative account.' => '操作拒否: 最後の管理者アカウントを削除することはできません。',
    'Account [_1] removed.'                                                       => 'アカウント [_1] を削除しました。',

    # -------------------------------------------------------------------------
    # Admin Dashboard & Navigation
    # -------------------------------------------------------------------------
    'Dashboard'                      => '管理ダッシュボード',
    'Manager'                        => 'ユーザー管理',
    'Page [_1] of [_2] ([_3] total)' => '[_1] / [_2] ページ（全 [_3] 件）',
    '← Prev'                         => '← 前へ',
    'Next →'                         => '次へ →',
    'Share link is active:'          => '共有リンクが有効化されました:',
    'Passcode:'                      => 'パスコード:',
    'Copy Info'                      => '情報をコピー',
    'Open ↗'                         => '開く ↗',
    'Files ([_1])'                   => 'ファイル一覧 ([_1])',
    'Active ([_1])'                  => '有効中 ([_1])',
    'Expired ([_1])'                 => '期限切れ ([_1])',
    'Trash ([_1])'                   => 'ゴミ箱 ([_1])',

    # -------------------------------------------------------------------------
    # Tab 1: Files
    # -------------------------------------------------------------------------
    'Drag & Drop files or folders here' => 'ファイルまたはフォルダをここにドラッグ＆ドロップ',
    'browse files'                      => 'ファイルを選択',
    'browse folder'                     => 'フォルダを選択',
    'Auto-extract if .zip archive'      => '.zip アーカイブの場合は自動展開する',
    'Preparing...'                      => '準備中...',
    'New Subfolder Name'                => '新しいサブフォルダ名',
    'New Root Folder Name'              => '新しいルートフォルダ名',
    'Create Folder'                     => 'フォルダ作成',
    'alphanumeric'                      => '半角英数字およびハイフン',
    'repository'                        => 'ストレージ',
    'Name'                              => '名前',
    'Modified'                          => '更新日時',
    'Actions'                           => '操作',
    '[_1] active'                       => '[_1] 件のアクティブ共有',
    'Share'                             => '共有リンク作成',
    'Move'                              => '移動',
    'Copy'                              => 'コピー',
    'Rename'                            => '名前を変更',
    'Delete this item permanently?'     => 'この項目を完全に削除してもよろしいですか？',

    # -------------------------------------------------------------------------
    # Tab 2: Active Shares
    # -------------------------------------------------------------------------
    'Active Shares ([_1])'             => '有効な共有 ([_1])',
    'Cute Slug'                        => '共有スラッグ (Slug)',
    'Target'                           => '対象パス',
    'Auth'                             => '認証',
    'TTL Remaining'                    => '残り有効期限',
    'Views / Quota'                    => 'アクセス数 / 上限',
    'Pronounce'                        => '発音を読み上げ',
    'Click to copy pwd'                => 'クリックしてパスコードをコピー',
    'Public'                           => '公開',
    'Never'                            => '無期限',
    '[_1] slots'                       => '[_1] 枠',
    '[_1] ago'                         => '[_1] 前',
    'Move this active share to trash?' => 'このアクティブな共有をゴミ箱に移動しますか？',

    # -------------------------------------------------------------------------
    # Tab 3: Expired Shares
    # -------------------------------------------------------------------------
    'Expired Shares ([_1])'                  => '期限切れの共有 ([_1])',
    'Move Selected to Trash'                 => '選択項目をゴミ箱に移動',
    'Move selected expired shares to trash?' => '選択した期限切れ共有をゴミ箱に移動しますか？',
    'Reason / Expired At'                    => '理由 / 期限日時',
    'Quota Exhausted'                        => 'アクセス枠終了',
    'Revoked'                                => '取り消し済み',
    'Renew & Edit'                           => '更新して再設定',
    'To Trash'                               => 'ゴミ箱へ',
    'Move share [_1] to trash?'              => '共有 [_1] をゴミ箱に移動しますか？',
    'No expired shares'                      => '期限切れの共有はありません',

    # -------------------------------------------------------------------------
    # Tab 4: Trash
    # -------------------------------------------------------------------------
    'Trash'                                                                 => 'ゴミ箱',
    'Empty Trash'                                                           => 'ゴミ箱を空にする',
    'WARNING: Permanently purge all items in trash? This cannot be undone.' => '警告: ゴミ箱内の全項目を完全に削除しますか？この操作は元に戻せません。',
    'Original Lifespan'                                                     => '元の有効期間',
    'Config: [_1][_2]'                                                      => '設定: [_1][_2]',
    'Permanent'                                                             => '無期限',
    'Restore'                                                               => '復元',
    'Purge'                                                                 => '完全削除',
    'Purge this config permanently?'                                        => 'この設定を完全に削除してもよろしいですか？',
    'Trash is empty'                                                        => 'ゴミ箱は空です',

    # -------------------------------------------------------------------------
    # Flash Notifications & Controller Error Messages
    # -------------------------------------------------------------------------
    'Share [_1] moved to Trash.'                                                           => '共有 [_1] をゴミ箱に移動しました。',
    'Share [_1] purged permanently.'                                                       => '共有 [_1] を完全に削除しました。',
    'Moved [_1] selected share(s) to Trash.'                                               => '選択した [_1] 件の共有をゴミ箱に移動しました。',
    'Moved [_1] expired shares to Trash.'                                                  => '期限切れの共有 [_1] 件をゴミ箱に移動しました。',
    'Purged [_1] items permanently from Trash.'                                            => 'ゴミ箱から [_1] 件を完全に削除しました。',
    'Renamed to [_1] successfully.'                                                        => '名前を [_1] に変更しました。',
    'Moved [_1] successfully.'                                                             => '[_1] の移動が完了しました。',
    'Copied [_1] successfully.'                                                            => '[_1] のコピーが完了しました。',
    'Directory [_1] deleted permanently.'                                                  => 'ディレクトリ [_1] を完全に削除しました。',
    'File [_1] deleted permanently.'                                                       => 'ファイル [_1] を完全に削除しました。',
    'The slug [_1] is a reserved system keyword.'                                          => 'スラッグ [_1] はシステム予約キーワードです。',
    'Share config [_1] not found anywhere.'                                                => '共有設定 [_1] が見つかりません。',
    'Invalid JSON payload for [_1].'                                                       => '共有 [_1] のメタデータ JSON が不正です。',
    'Target [_1] missing on disk. Cleaned.'                                                => '対象 [_1] がディスク上に存在しないため、クリーンアップしました。',
    'Modification prohibited: Resource actively occupied by [_1]. Revoke the share first.' => '変更禁止: リソースは現在 [_1] に使用されています。先に共有を取り消してください。',
    'Move prohibited: Resource actively occupied by [_1]. Revoke share first.'             => '移動禁止: リソースは現在 [_1] に使用されています。先に共有を取り消してください。',
    'Deletion prohibited: Resource actively occupied by [_1]. Revoke the share first.'     => '削除禁止: リソースは現在 [_1] に使用されています。先に共有を取り消してください。',
    'Move failed: Target entity [_1] already exists in destination.'                       => '移動失敗: 移動先に同名のリソース [_1] が既に存在します。',
    'Copy failed: Target entity [_1] already exists in destination.'                       => 'コピー失敗: コピー先に同名のリソース [_1] が既に存在します。',
    'Upload rejected: [_1]'                                                                => 'アップロードが拒否されました: [_1]',
    'Invalid folder name.'                                                                 => 'フォルダ名が無効です。',
    'Security Alert: CSRF token validation failed. Action rejected.'                       => 'セキュリティ警告: CSRF トークンの検証に失敗しました。操作は拒否されました。',
    'Security Alert: Directory traversal detected.'                                        => 'セキュリティ警告: ディレクトリトラバーサルが検出されました。',
    'Security Alert: Access to hidden or system files is strictly restricted.'             => 'セキュリティ警告: 隠しファイルやシステムメタデータへのアクセスは制限されています。',
    'Security Alert: Unauthorized deletion path.'                                          => 'セキュリティ警告: 不正な削除パスが指定されました。',
    'Move failed: Invalid source or destination path.'                                     => '移動失敗: 移動元または移動先のパスが無効です。',
    'Move failed: Cannot move a directory into its own subdirectory.'                      => '移動失敗: ディレクトリを自分自身のサブディレクトリ内に移動することはできません。',
    'Copy failed: Invalid source or destination path.'                                     => 'コピー失敗: コピー元またはコピー先のパスが無効です。',

    # -------------------------------------------------------------------------
    # Guest & Delivery Handlers (新增補充)
    # -------------------------------------------------------------------------
    'Internal Server Error'                                             => '内部サーバーエラー',
    'Corrupted share metadata configuration.'                           => '共有メタデータの構成が破損しています。',
    'Forbidden'                                                         => 'アクセスが拒否されました',
    'Automated access detected.'                                        => '自動化されたボットやクローラーからのアクセスを検出しました。',
    'Too Many Requests'                                                 => 'リクエストが多すぎます',
    'Too many verification attempts. Please wait.'                      => '認証試行回数が多すぎます。しばらく待ってから再試行してください。',
    'Unauthorized'                                                      => '認証されていません',
    'Reserved endpoint'                                                 => '予約済みシステムエンドポイント',
    'Target Missing'                                                    => '対象が存在しません',
    'The underlying file or directory has been removed from storage.'   => '対象のファイルまたはディレクトリはストレージから削除されました。',
    'Target [_1] does not exist.'                                       => '対象 [_1] は存在しません。',
    'Directory traversal or unauthorized path access detected.'         => 'ディレクトリトラバーサルまたは不正なパスへのアクセスが検出されました。',
    'Access Denied'                                                     => 'アクセス拒否',
    'Access to hidden files or system metadata is strictly prohibited.' => '隠しファイルやシステムメタデータへのアクセスは固く禁じられています。',
    'Library Not Found'                                                 => '共有ライブラリが見つかりません',
    'Virtual shared library [_1] does not exist in libs/.'              => '仮想共有ライブラリ [_1] は libs/ 内に存在しません。',

    # -------------------------------------------------------------------------
    # Dialogs & Form Labels
    # -------------------------------------------------------------------------
    'New Share Link'                                           => '新しい共有リンクを作成',
    'Lifespan (0 = Permanent)'                                 => '有効期間 (0 = 無期限)',
    'Max Access Slots (0 = Unlimited / No Burn)'               => '最大アクセス枠 (0 = 無制限 / 破棄なし)',
    'Custom Cute Slug (Optional)'                              => 'カスタムスラッグ (省略可)',
    'Access Password (Plain text, optional)'                   => 'アクセスパスワード (平文、省略時は公開)',
    'Note (Shown on showcase page)'                            => '備考メモ (プレビュー画面に表示)',
    'Cancel'                                                   => 'キャンセル',
    'Create'                                                   => '作成',
    'Edit / Restore Share'                                     => '共有設定の編集 / 復元',
    'Target (Change file or directory to switch version)'      => '対象 (ファイルやディレクトリを変更してバージョン切り替え)',
    'Type to search paths...'                                  => 'パスを入力して検索...',
    'New Lifespan (0 = Permanent)'                             => '新しい有効期間 (0 = 無期限)',
    'Max Access Slots (0 = Unlimited)'                         => '最大アクセス枠 (0 = 無制限)',
    'Password (Leave empty to keep, type __CLEAR__ to remove)' => 'パスワード (空欄で維持、__CLEAR__ で解除)',
    'Save & Activate'                                          => '保存して有効化',
    'Confirm'                                                  => '確認',
    'Move Resource'                                            => 'リソースを移動',
    'Copy Resource'                                            => 'リソースをコピー',
    'Destination Directory (Empty for root level)'             => '移動先ディレクトリ (空欄でルート直下)',
    'Type to search folders...'                                => 'フォルダを入力して検索...',
    'Confirm Move'                                             => '移動を実行',
    'Confirm Copy'                                             => 'コピーを実行',
    'Root directory'                                           => 'ルートディレクトリ',
    'Gen'                                                      => '生成',
    'Leave empty to keep intact'                               => '変更しない場合は空欄',
    'Note'                                                     => '備考メモ',
    'e.g. Project assets download'                             => '例: プロジェクト資料ダウンロード',
    'Leave empty for public access'                            => '公開する場合は空欄のまま',
    'New Name'                                                 => '新しい名前',

    # -------------------------------------------------------------------------
    # Time Units & Countdown
    # -------------------------------------------------------------------------
    'Seconds' => '秒',
    'Minutes' => '分',
    'Hours'   => '時間',
    'Days'    => '日',
    'Weeks'   => '週間',
    'Months'  => 'ヶ月',
    'Years'   => '年',
    's left'  => '秒後に期限切れ',
    'm left'  => '分後に期限切れ',
    'h left'  => '時間後に期限切れ',
    'd left'  => '日後に期限切れ',
    'Expired' => '期限切れ',

    # -------------------------------------------------------------------------
    # Client-Side JavaScript Strings
    # -------------------------------------------------------------------------
    'Copied link: [_1]'                     => 'リンクをコピーしました: [_1]',
    'Copy manually:'                        => '手動でコピーしてください:',
    'Uploading [_1] file(s)... ([_2]%)'     => '[_1] 件のファイルをアップロード中... ([_2]%)',
    'Upload failed: '                       => 'アップロードに失敗しました: ',
    'Network error occurred during upload.' => 'アップロード中にネットワークエラーが発生しました。',

    # -------------------------------------------------------------------------
    # Default Public Portal
    # -------------------------------------------------------------------------
    'File Sharing Node'                        => 'ファイル共有ノード',
    'Private sharing portal is active.'        => 'プライベート共有ポータルは正常に稼働しています。',
    'Direct access requires a dedicated link.' => 'アクセスには専用の共有リンクが必要です。',
);

1;
