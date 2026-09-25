package Fogshare::I18N::ko;
#
# Fogshare - Korean Lexicon (ko)
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

use Mojo::Base 'Fogshare::I18N';

our %Lexicon = (

    # -------------------------------------------------------------------------
    # General & Base
    # -------------------------------------------------------------------------
    'Error'                                                    => '오류',
    'Page Not Found'                                           => '페이지를 찾을 수 없습니다',
    'Not Found'                                                => '리소스를 찾을 수 없습니다',
    'The requested resource or sharing portal does not exist.' => '요청한 리소스 또는 공유 링크가 존재하지 않습니다.',
    'The requested resource was not found on this server.'     => '이 서버에서 요청한 리소스를 찾을 수 없습니다.',
    'Go Back'                                                  => '뒤로 가기',
    'Return Home'                                              => '홈으로 돌아가기',
    'Toggle theme'                                             => '테마 전환',
    'Scan to View on Mobile'                                   => '모바일로 QR 코드 스캔',
    'QR Code'                                                  => 'QR 코드',

    # -------------------------------------------------------------------------
    # Directory Showcase (directory.html.ep)
    # -------------------------------------------------------------------------
    'Directory Index' => '디렉터리 색인',
    'File Name'       => '파일 이름',
    'Size'            => '크기',
    'Action'          => '작업',
    '.. (Parent)'     => '.. (상위 디렉터리)',
    'Download'        => '다운로드',
    'Empty directory' => '빈 디렉터리',

    # -------------------------------------------------------------------------
    # Expired Notice (expired.html.ep)
    # -------------------------------------------------------------------------
    '410 Gone'                                                      => '410 만료된 공유',
    'This share link has expired or has been revoked by the owner.' => '이 공유 링크는 만료되었거나 소유자에 의해 취소되었습니다.',

    # -------------------------------------------------------------------------
    # Gate & Access Control (gate.html.ep)
    # -------------------------------------------------------------------------
    'Protected Access'                                             => '보호된 액세스',
    'Protected Resource'                                           => '보호된 리소스',
    'Please enter the passcode to access this share.'              => '이 공유에 액세스하려면 암호를 입력하십시오.',
    'Passcode'                                                     => '액세스 암호',
    'Unlock'                                                       => '잠금 해제',
    'Session remains valid for 24 hours'                           => '세션은 24시간 동안 유지됩니다',
    'Invalid passcode'                                             => '암호가 일치하지 않습니다',
    'Too many failed attempts. Temporarily locked for 15 minutes.' => '시도 횟수를 초과했습니다. 15분 동안 일시적으로 잠깁니다.',

    # -------------------------------------------------------------------------
    # Gatekeeper / Burn-After-Reading Quota (gatekeeper.html.ep)
    # -------------------------------------------------------------------------
    'Ephemeral Access'                                              => '열람 후 파기 공유',
    'Ephemeral Drop'                                                => '일회성 전송',
    'Limited drop: [_1] access slots remaining.'                    => '제한된 공유: 남은 액세스 횟수 [_1]회.',
    'Remaining Slots: [_1]'                                         => '남은 액세스 슬롯: [_1]',
    'Click below to claim an access slot and bind to this session.' => '아래 버튼을 눌러 액세스 슬롯 1회를 사용하고 현재 세션에 연결합니다.',
    'Reveal Content'                                                => '콘텐츠 열람하기',

    # -------------------------------------------------------------------------
    # Authentication (login.html.ep)
    # -------------------------------------------------------------------------
    'Admin Login'                                       => '관리자 로그인',
    'Authenticate with your administrator credentials.' => '관리자 계정으로 로그인하십시오.',
    'Username'                                          => '사용자 이름',
    'Password'                                          => '비밀번호',
    'Sign In'                                           => '로그인',
    'Invalid username or password'                      => '사용자 이름 또는 비밀번호가 잘못되었습니다',
    'Logged out successfully.'                          => '성공적으로 로그아웃되었습니다.',

    # -------------------------------------------------------------------------
    # Showcase Page (showcase.html.ep)
    # -------------------------------------------------------------------------
    'Preview not available for this file type' => '이 파일 형식은 미리보기를 지원하지 않습니다',
    'Direct Download'                          => '직접 다운로드',

    # -------------------------------------------------------------------------
    # User Manager (users.html.ep & Controller/Users.pm)
    # -------------------------------------------------------------------------
    'Account Manager'                                                             => '계정 관리',
    'Admin Settings'                                                              => '관리자 설정',
    'Manage administrator credentials for this node.'                             => '이 노드의 관리자 계정 자격 증명을 관리합니다.',
    'Edit'                                                                        => '수정',
    'Delete'                                                                      => '삭제',
    'You'                                                                         => '현재 사용자',
    'Delete user [_1]?'                                                           => '사용자 [_1]을(를) 삭제하시겠습니까?',
    'New Password'                                                                => '새 비밀번호',
    'Save / Update'                                                               => '저장 / 업데이트',
    'Update [_1]'                                                                 => '[_1] 수정',
    '← Console'                                                                   => '← 관리 콘솔',
    'Logout'                                                                      => '로그아웃',
    'Validation failed: Username must be >= 3 chars and password >= 6 chars.'     => '유효성 검사 실패: 사용자 이름은 최소 3자, 비밀번호는 최소 6자여야 합니다.',
    'Account [_1] updated successfully.'                                          => '계정 [_1]이(가) 저장되었습니다.',
    'Action prohibited: You cannot delete your currently logged-in account.'      => '작업 제한: 현재 로그인된 계정은 삭제할 수 없습니다.',
    'Action prohibited: Cannot remove the last remaining administrative account.' => '작업 제한: 마지막 남은 관리자 계정은 삭제할 수 없습니다.',
    'Account [_1] removed.'                                                       => '계정 [_1]이(가) 삭제되었습니다.',

    # -------------------------------------------------------------------------
    # Admin Dashboard & Navigation
    # -------------------------------------------------------------------------
    'Dashboard'                      => '관리 대시보드',
    'Manager'                        => '사용자 관리',
    'Page [_1] of [_2] ([_3] total)' => '[_1] / [_2] 페이지 (총 [_3]건)',
    '← Prev'                         => '← 이전',
    'Next →'                         => '다음 →',
    'Share link is active:'          => '공유 링크가 활성화되었습니다:',
    'Passcode:'                      => '액세스 암호:',
    'Copy Info'                      => '공유 정보 복사',
    'Open ↗'                         => '열기 ↗',
    'Files ([_1])'                   => '파일 보관함 ([_1])',
    'Active ([_1])'                  => '활성 상태 ([_1])',
    'Expired ([_1])'                 => '만료됨 ([_1])',
    'Trash ([_1])'                   => '휴지통 ([_1])',

    # -------------------------------------------------------------------------
    # Tab 1: Files
    # -------------------------------------------------------------------------
    'Drag & Drop files or folders here' => '파일이나 폴더를 여기에 끌어다 놓으세요',
    'browse files'                      => '파일 선택',
    'browse folder'                     => '폴더 선택',
    'Auto-extract if .zip archive'      => '.zip 압축 파일인 경우 자동 압축 해제',
    'Preparing...'                      => '준비 중...',
    'New Subfolder Name'                => '새 하위 폴더 이름',
    'New Root Folder Name'              => '새 루트 폴더 이름',
    'Create Folder'                     => '폴더 생성',
    'alphanumeric'                      => '영숫자 및 하이픈',
    'repository'                        => '저장소',
    'Name'                              => '이름',
    'Modified'                          => '수정일',
    'Actions'                           => '작업',
    '[_1] active'                       => '[_1]개 활성 공유',
    'Share'                             => '공유 생성',
    'Move'                              => '이동',
    'Copy'                              => '복사',
    'Rename'                            => '이름 변경',
    'Delete this item permanently?'     => '이 항목을 영구적으로 삭제하시겠습니까?',

    # -------------------------------------------------------------------------
    # Tab 2: Active Shares
    # -------------------------------------------------------------------------
    'Active Shares ([_1])'             => '활성 공유 ([_1])',
    'Cute Slug'                        => '단축 식별자 (Slug)',
    'Target'                           => '대상 경로',
    'Auth'                             => '인증',
    'TTL Remaining'                    => '남은 유효 기간',
    'Views / Quota'                    => '조회수 / 정원',
    'Pronounce'                        => '발음 듣기',
    'Click to copy pwd'                => '암호 복사',
    'Public'                           => '공개',
    'Never'                            => '무제한',
    '[_1] slots'                       => '[_1] 슬롯',
    '[_1] ago'                         => '[_1] 전',
    'Move this active share to trash?' => '이 활성 공유를 휴지통으로 이동하시겠습니까?',

    # -------------------------------------------------------------------------
    # Tab 3: Expired Shares
    # -------------------------------------------------------------------------
    'Expired Shares ([_1])'                  => '만료된 공유 ([_1])',
    'Move Selected to Trash'                 => '선택 항목 휴지통으로 이동',
    'Move selected expired shares to trash?' => '선택한 만료된 공유를 휴지통으로 이동하시겠습니까?',
    'Reason / Expired At'                    => '만료 원인 / 만료 시간',
    'Quota Exhausted'                        => '슬롯 정원 소진',
    'Revoked'                                => '수동 취소됨',
    'Renew & Edit'                           => '기간 연장 및 수정',
    'To Trash'                               => '휴지통으로',
    'Move share [_1] to trash?'              => '공유 [_1]을(를) 휴지통으로 이동하시겠습니까?',
    'No expired shares'                      => '만료된 공유가 없습니다',

    # -------------------------------------------------------------------------
    # Tab 4: Trash
    # -------------------------------------------------------------------------
    'Trash'                                                                 => '휴지통',
    'Empty Trash'                                                           => '휴지통 비우기',
    'WARNING: Permanently purge all items in trash? This cannot be undone.' => '경고: 휴지통의 모든 항목을 영구적으로 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.',
    'Original Lifespan'                                                     => '원래 유효 기간',
    'Config: [_1][_2]'                                                      => '설정: [_1][_2]',
    'Permanent'                                                             => '무제한',
    'Restore'                                                               => '공유 복원',
    'Purge'                                                                 => '영구 파기',
    'Purge this config permanently?'                                        => '이 설정을 영구적으로 파기하시겠습니까?',
    'Trash is empty'                                                        => '휴지통이 비어 있습니다',

    # -------------------------------------------------------------------------
    # Flash Notifications & Controller Error Messages
    # -------------------------------------------------------------------------
    'Share [_1] moved to Trash.'                                                           => '공유 [_1]이(가) 휴지통으로 이동되었습니다.',
    'Share [_1] purged permanently.'                                                       => '공유 [_1]이(가) 영구 삭제되었습니다.',
    'Moved [_1] selected share(s) to Trash.'                                               => '선택한 [_1]개의 공유를 휴지통으로 이동했습니다.',
    'Moved [_1] expired shares to Trash.'                                                  => '만료된 공유 [_1]개를 휴지통으로 이동했습니다.',
    'Purged [_1] items permanently from Trash.'                                            => '휴지통에서 [_1]개 항목을 영구 삭제했습니다.',
    'Renamed to [_1] successfully.'                                                        => '이름을 [_1](으)로 변경했습니다.',
    'Moved [_1] successfully.'                                                             => '[_1] 이동이 완료되었습니다.',
    'Copied [_1] successfully.'                                                            => '[_1] 복사가 완료되었습니다.',
    'Directory [_1] deleted permanently.'                                                  => '디렉터리 [_1]이(가) 영구 삭제되었습니다.',
    'File [_1] deleted permanently.'                                                       => '파일 [_1]이(가) 영구 삭제되었습니다.',
    'The slug [_1] is a reserved system keyword.'                                          => '식별자 [_1]은(는) 시스템 예약 키워드입니다.',
    'Share config [_1] not found anywhere.'                                                => '공유 설정 [_1]을(를) 찾을 수 없습니다.',
    'Invalid JSON payload for [_1].'                                                       => '공유 [_1]의 메타데이터 JSON이 잘못되었습니다.',
    'Target [_1] missing on disk. Cleaned.'                                                => '대상 경로 [_1]이(가) 디스크에 없어 정리되었습니다.',
    'Modification prohibited: Resource actively occupied by [_1]. Revoke the share first.' => '수정 제한: 리소스가 현재 [_1]에 의해 점유 중입니다. 먼저 공유를 취소하세요.',
    'Move prohibited: Resource actively occupied by [_1]. Revoke share first.'             => '이동 제한: 리소스가 현재 [_1]에 의해 점유 중입니다. 먼저 공유를 취소하세요.',
    'Deletion prohibited: Resource actively occupied by [_1]. Revoke the share first.'     => '삭제 제한: 리소스가 현재 [_1]에 의해 점유 중입니다. 먼저 공유를 취소하세요.',
    'Move failed: Target entity [_1] already exists in destination.'                       => '이동 실패: 대상 위치에 동일한 이름의 리소스 [_1]이(가) 이미 존재합니다.',
    'Copy failed: Target entity [_1] already exists in destination.'                       => '복사 실패: 대상 위치에 동일한 이름의 리소스 [_1]이(가) 이미 존재합니다.',
    'Upload rejected: [_1]'                                                                => '업로드 거부됨: [_1]',
    'Invalid folder name.'                                                                 => '폴더 이름이 잘못되었습니다.',
    'Security Alert: CSRF token validation failed. Action rejected.'                       => '보안 경고: CSRF 토큰 유효성 검사에 실패하여 작업이 거부되었습니다.',
    'Security Alert: Directory traversal detected.'                                        => '보안 경고: 디렉터리 탐색 공격이 감지되었습니다.',
    'Security Alert: Access to hidden or system files is strictly restricted.'             => '보안 경고: 숨김 파일 또는 시스템 메타데이터 접근이 엄격히 금지됩니다.',
    'Security Alert: Unauthorized deletion path.'                                          => '보안 경고: 권한이 없는 비정상적인 삭제 경로입니다.',
    'Move failed: Invalid source or destination path.'                                     => '이동 실패: 원본 또는 대상 경로가 잘못되었습니다.',
    'Move failed: Cannot move a directory into its own subdirectory.'                      => '이동 실패: 디렉터리를 자신의 하위 디렉터리로 이동할 수 없습니다.',
    'Copy failed: Invalid source or destination path.'                                     => '복사 실패: 원본 또는 대상 경로가 잘못되었습니다.',

    # -------------------------------------------------------------------------
    # Guest & Delivery Handlers (新增補充)
    # -------------------------------------------------------------------------
    'Internal Server Error'                                             => '내부 서버 오류',
    'Corrupted share metadata configuration.'                           => '손상된 공유 메타데이터 구성입니다.',
    'Forbidden'                                                         => '접근이 거부되었습니다',
    'Automated access detected.'                                        => '자동화 봇 및 크롤러의 접근이 감지되었습니다.',
    'Too Many Requests'                                                 => '요청 횟수 초과',
    'Too many verification attempts. Please wait.'                      => '인증 시도 횟수가 너무 많습니다. 잠시 후 다시 시도해 주세요.',
    'Unauthorized'                                                      => '권한 없음',
    'Reserved endpoint'                                                 => '시스템 예약 엔드포인트',
    'Target Missing'                                                    => '대상을 찾을 수 없음',
    'The underlying file or directory has been removed from storage.'   => '해당 파일 또는 디렉터리가 저장소에서 삭제되었습니다.',
    'Target [_1] does not exist.'                                       => '대상 [_1]이(가) 존재하지 않습니다.',
    'Directory traversal or unauthorized path access detected.'         => '디렉터리 탐색 또는 승인되지 않은 경로 접근이 감지되었습니다.',
    'Access Denied'                                                     => '접근 거부됨',
    'Access to hidden files or system metadata is strictly prohibited.' => '숨김 파일 또는 시스템 메타데이터 접근은 엄격히 금지됩니다.',
    'Library Not Found'                                                 => '공유 라이브러리를 찾을 수 없음',
    'Virtual shared library [_1] does not exist in libs/.'              => '가상 공유 라이브러리 [_1]이(가) libs/ 에 존재하지 않습니다.',

    # -------------------------------------------------------------------------
    # Dialogs & Form Labels
    # -------------------------------------------------------------------------
    'New Share Link'                                           => '새 공유 링크 생성',
    'Lifespan (0 = Permanent)'                                 => '유효 기간 (0 = 영구적)',
    'Max Access Slots (0 = Unlimited / No Burn)'               => '최대 액세스 슬롯 (0 = 무제한 / 자동 파기 없음)',
    'Custom Cute Slug (Optional)'                              => '사용자 정의 식별자 (선택 사항)',
    'Access Password (Plain text, optional)'                   => '액세스 암호 (일반 텍스트, 비워두면 공개)',
    'Note (Shown on showcase page)'                            => '메모 (미리보기 화면에 표시됨)',
    'Cancel'                                                   => '취소',
    'Create'                                                   => '생성',
    'Edit / Restore Share'                                     => '공유 수정 / 복원',
    'Target (Change file or directory to switch version)'      => '대상 경로 (파일이나 폴더를 변경하여 버전 전환)',
    'Type to search paths...'                                  => '경로를 입력하여 검색...',
    'New Lifespan (0 = Permanent)'                             => '새 유효 기간 (0 = 영구적)',
    'Max Access Slots (0 = Unlimited)'                         => '최대 액세스 슬롯 (0 = 무제한)',
    'Password (Leave empty to keep, type __CLEAR__ to remove)' => '암호 (비워두면 유지, __CLEAR__ 입력 시 제거)',
    'Save & Activate'                                          => '저장 및 활성화',
    'Confirm'                                                  => '확인',
    'Move Resource'                                            => '리소스 이동',
    'Copy Resource'                                            => '리소스 복사',
    'Destination Directory (Empty for root level)'             => '대상 디렉터리 (비워두면 루트 레벨)',
    'Type to search folders...'                                => '폴더 이름을 입력하여 검색...',
    'Confirm Move'                                             => '이동 확인',
    'Confirm Copy'                                             => '복사 확인',
    'Root directory'                                           => '루트 디렉터리',
    'Gen'                                                      => '생성',
    'Leave empty to keep intact'                               => '변경하지 않으려면 비워두기',
    'Note'                                                     => '메모',
    'e.g. Project assets download'                             => '예: 프로젝트 리소스 다운로드',
    'Leave empty for public access'                            => '공개 접근 시 비워두기',
    'New Name'                                                 => '새 이름',

    # -------------------------------------------------------------------------
    # Time Units & Countdown
    # -------------------------------------------------------------------------
    'Seconds' => '초',
    'Minutes' => '분',
    'Hours'   => '시간',
    'Days'    => '일',
    'Weeks'   => '주',
    'Months'  => '개월',
    'Years'   => '년',
    's left'  => '초 후 만료',
    'm left'  => '분 후 만료',
    'h left'  => '시간 후 만료',
    'd left'  => '일 후 만료',
    'Expired' => '만료됨',

    # -------------------------------------------------------------------------
    # Client-Side JavaScript Strings
    # -------------------------------------------------------------------------
    'Copied link: [_1]'                     => '링크 복사됨: [_1]',
    'Copy manually:'                        => '수동으로 복사하세요:',
    'Uploading [_1] file(s)... ([_2]%)'     => '[_1]개 파일 업로드 중... ([_2]%)',
    'Upload failed: '                       => '업로드 실패: ',
    'Network error occurred during upload.' => '업로드 중 네트워크 오류가 발생했습니다.',

    # -------------------------------------------------------------------------
    # Default Public Portal
    # -------------------------------------------------------------------------
    'File Sharing Node'                        => '파일 공유 노드',
    'Private sharing portal is active.'        => '프라이빗 공유 포털이 정상 작동 중입니다.',
    'Direct access requires a dedicated link.' => '파일에 액세스하려면 전용 공유 링크가 필요합니다.',
);

1;
