(define-module (slicer)
  #:use-module ((guix licenses)
                #:prefix licenses:)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages version-control)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system copy)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1))

;;; -------------------- CTKAppLauncher---------------------------------------

(define ctkapplauncher
  (package
    (name "ctkapplauncher")
    (version "0.1.0")
    (source
     (origin
       (method url-fetch)
       (uri "https://github.com/commontk/AppLauncher/archive/8759e03985738b8a8f3eb74ab516ba4e8ef29988.tar.gz")
       (sha256
        (base32 "1lrrcg9s39n357z2dhfhv8ff99biivdnwwxaggwvnpv9knppaz83"))))
    (build-system cmake-build-system)
    (inputs
     (list qtbase-5))
    (arguments
     (list
      #:tests? #f ;There are no tests.
      #:configure-flags #~(list "-DBUILD_TESTING:BOOL=OFF"
                                "-DCTKAppLauncher_QT_VERSION:STRING=5")))
    (home-page "https://github.com/commontk/ctkapplauncher")
    (synopsis "CTK Application Launcher")
    (description
     "Application launcher with the ability to set up environment for the running application")
    (license licenses:asl2.0)))


;;; -------------------- 3D Slicer -------------------------------------------

(define license-record (@ (guix licenses) license))

(define slicer-license
  (license-record "Slicer"
                  "https://github.com/slicer/blob/main/license.txt"
                  "https://slicer.readthedocs.io/en/latest/user_guide/about.html#license"))

(define vcs-file?
  (or (git-predicate (string-append (current-source-directory) "/../../"))
      (const #t)))

(define-public slicer-desktop-5.8
  (package
    (name "slicer-desktop-5.8")
    (version "5.8.1")
    (source (local-file "../.." "slicer-desktop-5.8-checkout"
                        #:recursive? #t
                        #:select? vcs-file?))
    (build-system cmake-build-system)
    (inputs
     `(("git" ,git)
       ("cmake" ,cmake-3.30)
       ("openssl" ,openssl)
       ("qtlocation-5" ,qtlocation-5)
       ("qtmultimedia-5" ,qtmultimedia-5)
       ("qtsvg-5" ,qtsvg-5)
       ("qttools-5" ,qttools-5)
       ("qtwebengine-5" ,qtwebengine-5)
       ("qtx11extras" ,qtx11extras)
       ("qtxmlpatterns" ,qtxmlpatterns)
       ;;; Slicer remote dependencies (in Superbuild.cmake)
       ("vtkaddon-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/Slicer/vtkAddon/archive/b5aa0615a6486b6bdceeb13bd59c2fb9f89cce42.tar.gz")
           (sha256
            (base32 "0wazsirav972mxkawfaw0lpnkylxfr19xjrd5s03blr2kid50a91"))))
       ("multivolumeexplorer-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/fedorov/MultiVolumeExplorer/archive/36102fd0ffae409319c0a0fee71dde1df64fe9e0.tar.gz")
           (sha256
            (base32 "14dbic1z2r9351ag48h5si0lrn8klrys8d852bwiw1pmlmhq7vvm"))))
       ("multivolumeimporter-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/fedorov/MultiVolumeImporter/archive/c8a37eb5e4f35b78ccc9287b298457a064c9d001.tar.gz")
           (sha256
            (base32 "0mpzmpan68psjz77qsmpj6dwi6gyfs2h3dv768b9408ldcbq2v6b"))))
       ("simplefilters-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/SimpleITK/SlicerSimpleFilters/archive/e82fc598bc010505e994b7ce22d953a9899a175c.tar.gz")
           (sha256
            (base32 "1yvvp3gb2vb5pgx988n2ga72dciv7yhp7k711xfs264sy1sir9mv"))))
       ("brainstools-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/BRAINSia/BRAINSTools/archive/3b3cfd0d45a35e924569ee930a29c4f6292a8d1f.tar.gz")
           (sha256
            (base32 "0nb740l1h4ddx8db75mp5qmvg3rb9mw4rgdnyf0chx0hw3hidx9b"))))
       ("comparevolumes-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/pieper/CompareVolumes/archive/cb755dda78f726cf9262aa4e1f75122c72a0df2f.tar.gz")
           (sha256
            (base32 "19qg8fw3af7ismgajx09ghapknn6c7ih2wbapckjxn9jq30ca2rb"))))
       ("landmarkregistration-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/Slicer/LandmarkRegistration/archive/aa23730ae78992cf14e858fe26ccfb213ea038ab.tar.gz")
           (sha256
            (base32 "04bkdgrk05g7aj04k1faj4mmcv7fz7dyz6z60b7hglb67d60n9r3"))))
       ("surfacetoolbox-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/Slicer/SlicerSurfaceToolbox/archive/e8b8f70930883adb6f4a227ad9d7339d20120f2c.tar.gz")
           (sha256
            (base32 "15ad5n5i66kr1rwmfq2c1cc3kp99iqbmqpf6vfji32f8zxhq8jbv"))))
       ;;; Slicer external dependencies (in Superbuild directory)
       ("zlib-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/commontk/zlib/archive/66a753054b356da85e1838a081aa94287226823e.tar.gz")
           (sha256
            (base32 "0ly0x5m1bvvyb9ifwar9pxmini9b063r0vl4w6i2rd03267gw9y3"))))
       ("curl-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/Slicer/curl/archive/d73e360a78d97adda85364e6bd5c504a2eb1572a.tar.gz")
           (sha256
            (base32 "03ccqlnk9mi9awvvgw4kpp8dj2jcvx5h28f52yky7kfnla5gw9w6"))))
       ("ctkapplauncherlib-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/commontk/AppLauncher/archive/8759e03985738b8a8f3eb74ab516ba4e8ef29988.tar.gz")
           (sha256
            (base32 "1lrrcg9s39n357z2dhfhv8ff99biivdnwwxaggwvnpv9knppaz83"))))
       ;;CTKAppLauncher
       ("ctkapplauncher" ,ctkapplauncher)
       ;;bzip2
       ("bzip2-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/commontk/bzip2/archive/391dddabd24aee4a06e10ab6636f26dd93c21308.tar.gz")
           (sha256
            (base32 "0ynm2xk670phjxf452gi04mmpc6wqq328c9g4ylnz7880rmqbv85"))))
       ;;libffi
       ("libffi-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/python-cmake-buildsystem/libffi/archive/e8599d9d5a50841c11a5ff8e3438dd12f080b096.tar.gz")
           (sha256
            (base32 "07v1fjggl02c2aq7y9d8nwv8nn60iss2y951lzgwlxg855l1l87h"))))
       ("lzma-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/xz-mirror/xz/archive/refs/tags/v5.2.5.tar.gz")
           (sha256
            (base32 "12n799mc2fwhbgbcqhh15bvgbvwmf4r2j1c10831mp8kkxi8jaqd"))))))
    (arguments
     (list #:tests? #f
           #:configure-flags #~(list "-DBUILD_TESTING:BOOL=OFF"
                                     "-DSlicer_DISABLE_HTTPS_CHECK:BOOL=ON"
                                     "-DSlicer_USE_SYSTEM_OpenSSL:BOOL=ON"
                                     ;; vtkAddon
                                     (string-append
                                      "-DvtkAddon_ARCHIVE:FILEPATH="
                                      #$(this-package-input "vtkaddon-src"))
                                     (string-append
                                      "-DvtkAddon_ARCHIVE_MD5:STRING="
                                      "8469bc071fefd247dbcf39de74657704")
                                     ;; MultiVolumeExplorer
                                     (string-append
                                      "-DMultiVolumeExplorer_ARCHIVE:FILEPATH="
                                      #$(this-package-input "multivolumeexplorer-src"))
                                     (string-append
                                      "-DMultiVolumeExplorer_ARCHIVE_MD5:STRING="
                                      "f7ad3659fe864f745fe885967ae4a443")
                                     ;; MultiVolumeImporter
                                     (string-append
                                      "-DMultiVolumeImporter_ARCHIVE:FILEPATH="
                                      #$(this-package-input "multivolumeexplorer-src"))
                                     (string-append
                                      "-DMultiVolumeImporter_ARCHIVE_MD5:STRING="
                                      "f7ad3659fe864f745fe885967ae4a443")
                                     ;; SimpleFilters
                                     (string-append
                                      "-DSimpleFilters_ARCHIVE:FILEPATH="
                                      #$(this-package-input "simplefilters-src"))
                                     (string-append
                                      "-DSimpleFilters_ARCHIVE_MD5:STRING="
                                      "64937b5b3e9bf2c8a24607115baab732")
                                     ;; BRAINSTools
                                     (string-append
                                      "-DBRAINSTools_ARCHIVE:FILEPATH="
                                      #$(this-package-input "brainstools-src"))
                                     (string-append
                                      "-DBRAINSTools_ARCHIVE_MD5:STRING="
                                      "d7ac725d5a9673816d2428e68d7b318d")
                                     ;; CompareVolumes
                                     (string-append
                                      "-DCompareVolumes_ARCHIVE:FILEPATH="
                                      #$(this-package-input "comparevolumes-src"))
                                     (string-append
                                      "-DCompareVolumes_ARCHIVE_MD5:STRING="
                                      "cd5296f50fee721ae5147d6f9be9305c")
                                     ;; LandmarkRegistration
                                     (string-append
                                      "-DLandmarkRegistration_ARCHIVE:FILEPATH="
                                      #$(this-package-input "landmarkregistration-src"))
                                     (string-append
                                      "-DLandmarkRegistration_ARCHIVE_MD5:STRING="
                                      "20242072f956c1edb26905fd71683754")
                                     ;; SurfaceToolbox
                                     (string-append
                                      "-DSurfaceToolbox_ARCHIVE:FILEPATH="
                                      #$(this-package-input "surfacetoolbox-src"))
                                     (string-append
                                      "-DSurfaceToolbox_ARCHIVE_MD5:STRING="
                                      "8c9aa3dca36e390431325af9778a7286")
                                     ;; zlib
                                     (string-append
                                      "-Dzlib_ARCHIVE:FILEPATH="
                                      #$(this-package-input "zlib-src"))
                                     (string-append
                                      "-Dzlib_ARCHIVE_MD5:STRING="
                                      "9f9ab02eb259dc3d81895aa0fa534620")
                                     ;; curl
                                     (string-append
                                      "-Dcurl_ARCHIVE:FILEPATH="
                                      #$(this-package-input "curl-src"))
                                     (string-append
                                      "-Dcurl_ARCHIVE_MD5:STRING="
                                      "8330412e835ac88200e0412f59475203")
                                     ;; ctkapplauncherlib
                                     (string-append
                                      "-DCTKAppLauncherLib_ARCHIVE:FILEPATH="
                                      #$(this-package-input "ctkapplauncherlib-src"))
                                     (string-append
                                      "-DCTKAppLauncherLib_ARCHIVE_MD5:STRING="
                                      "c2fb456dad59c31559c9b345f0971efb")
                                     ;; ctkapplauncher
                                     (string-append
                                      "-DCTKAppLauncher_DIR:PATH="
                                      #$(this-package-input "ctkapplauncher"))
                                     ;;bzip2
                                     (string-append
                                      "-Dbzip2_ARCHIVE:FILEPATH="
                                      #$(this-package-input "bzip2-src"))
                                     (string-append
                                      "-Dbzip2_ARCHIVE_MD5:STRING="
                                      "f6c635378f9687eadb0daf58ce609e98")
                                     ;;libffi
                                     (string-append
                                      "-DLibFFI_ARCHIVE:FILEPATH="
                                      #$(this-package-input "libffi-src"))
                                     (string-append
                                      "-DLibFFI_ARCHIVE_MD5:STRING="
                                      "ca0dc8674a5d7fa9dbc96a762fcc6d20")
                                     ;;lzma
                                     (string-append
                                      "-DLZMA_ARCHIVE:FILEPATH="
                                      #$(this-package-input "lzma-src"))
                                     (string-append
                                      "-DLZMA_ARCHIVE_MD5:STRING="
                                      "1380da72b651c2e96f76958e29c1fa68")

                                     )))
    (home-page "https://slicer.org")
    (synopsis "3D Slicer")
    (description
     "Medical-image computing")
    (license slicer-license)))

slicer-desktop-5.8
