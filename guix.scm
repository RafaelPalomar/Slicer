(define-module (slicer)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix build utils)
  #:use-module (guix build-system)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses)
  #:use-module (gnu packages)
  #:use-module (gnu packages ccache)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages base)
  #:use-module (gnu packages version-control)
  #:use-module (ice-9 match)
  #:use-module (ice-9 ftw)
  #:use-module (srfi srfi-1))

(setenv "CCACHE_DIR" "/tmp/ccache")

(define vcs-file?
  ;; Return true if the given file is under version control.
  (or (git-predicate (current-source-directory))
      (const #t)))                                ;not in a Git checkout

(define license (@@ (guix licenses) license))



(define slicer-license-5.8
  (license "3D Slicer"
           "https://github.com/Slicer/Slicer/blob/5.8/License.txt"
           "https://slicer.readthedocs.io/en/latest/user_guide/about.html#license"))


;; (define-public pcre
;;   (package
;;     (name "pcre")
;;     (version "8.44")
;;     (source
;;       (origin
;;          (method git-fetch)
;;          (uri (git-reference
;;                (url "https://github.com/commontk/AppLauncher.git")
;;                (commit "8759e03985738b8a8f3eb74ab516ba4e8ef29988")))
;;          (sha256 (base32 "1d74gkpnl0rn9fbkij111zzwsxir57cgirgr4pj7xlslkiplg26i"))))
;;     (build-system cmake-build-system)

;;   (arguments
;;    (list #:build-type "Release"
;;          #:configure-flags
;;          #~(list
;;            "-DCTKAppLauncher_QT_VERSION:STRING=5"
;;            "-DBUILD_TESTING:BOOL=OFF")
;;          #:tests? #f))
;;   (inputs
;;     `(("bash" ,bash)
;;       ))))

(define-public ctkapplauncher
  (package
    (name "ctkapplauncher")
    (version "0.1.31")
    (source
      (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/commontk/AppLauncher.git")
               (commit "8759e03985738b8a8f3eb74ab516ba4e8ef29988")))
         (sha256 (base32 "1d74gkpnl0rn9fbkij111zzwsxir57cgirgr4pj7xlslkiplg26i"))))
    (build-system cmake-build-system)

  (arguments
   (list #:build-type "Release"
         #:configure-flags
         #~(list
           "-DCTKAppLauncher_QT_VERSION:STRING=5"
           "-DBUILD_TESTING:BOOL=OFF")
         #:tests? #f))
  (inputs
    `(("qtbase" ,qtbase-5)
      ("qttools" ,qttools-5)
      ("qtx11extras" ,qtx11extras)
      ("qtxmlpatterns" ,qtxmlpatterns)
      ("qtmultimedia" ,qtmultimedia-5)
      ("qtsvg" ,qtsvg-5)
      ("qtwebengine" ,qtwebengine-5)
      ("qtlocation" ,qtlocation-5)
      ("openssl" ,openssl-3.0)
      ("curl" ,curl)
      ("bzip2" ,bzip2)
      ("zlib" ,zlib)
      ("ccache" ,ccache)
      ("cmake" ,cmake-3.30)
      ("git" ,git)))
    (home-page "https://slicer.org")
    (synopsis "Platform for Medical Image Computing")
    (description
     "")
    (license slicer-license-5.8)))


(define-public slicer-desktop
  (package
    (name "slicer-desktop")
    (version "5.8.0")
    (source (local-file "." "slicer-checkout"
                        #:recursive? #t
                        #:select? vcs-file?))
  (build-system cmake-build-system)
  (arguments
   (list #:modules '((guix build cmake-build-system)
                     (guix build utils)
                     (ice-9 ftw))
         #:build-type "Release"           ;Build without '-g' to save space.
         #:configure-flags
         #~(list
           "-DBUILD_TESTING:BOOL=OFF"
           "-DSlicer_DISABLE_HTTPS_CHECK:BOOL=ON"
           "-DSlicer_USE_SYSTEM_OpenSSL:BOOL=ON"
           "-DSlicer_USE_SYSTEM_bzip2:BOOL=ON"
           "-DSlicer_USE_SYSTEM_zlib:BOOL=OFF"
           (string-append "-DCMAKE_CXX_COMPILER_LAUNCHER="
                          #+ccache "/bin/ccache")
           (string-append "-DCMAKE_C_COMPILER_LAUNCHER="
                          #+ccache "/bin/ccache")
           (string-append "-DCURL_INCLUDE_DIR="
                          #$(this-package-input "curl")
                          "/include")
           (string-append "-DCURL_LIBRARY="
                          #$(this-package-input "curl")
                          "/lib/libcurl.so")
           (string-append "-DBZIP2_INCLUDE_DIR="
                          #$(this-package-input "bzip2")
                          "/include")
           (string-append "-DBZIP2_LIBRARIES="
                          #$(this-package-input "bzip2")
                          "/lib/libbzip2.so")
           (string-append "-DvtkAddon_SOURCE_DIR="
                          #$(this-package-input "vtkAddon"))
           (string-append "-DMultiVolumeExplorer_SOURCE_DIR="
                          #$(this-package-input "MultiVolumeExplorer"))
           (string-append "-DMultiVolumeImporter_SOURCE_DIR="
                          #$(this-package-input "MultiVolumeImporter"))
           (string-append "-DSimpleFilters_SOURCE_DIR="
                          #$(this-package-input "SimpleFilters"))
           (string-append "-DBRAINSTools_SOURCE_DIR="
                          #$(this-package-input "BRAINSTools"))
           (string-append "-DCompareVolumes_SOURCE_DIR="
                          #$(this-package-input "CompareVolumes"))
           (string-append "-DLandmarkRegistration_SOURCE_DIR="
                          #$(this-package-input "LandmarkRegistration"))
           (string-append "-DSurfaceToolbox_SOURCE_DIR="
                          #$(this-package-input "SurfaceToolbox"))
           (string-append "-DZLIB_SOURCE_DIR="
                          #$(this-package-input "zlib"))
           (string-append "-DSlicer_CTKAppLauncherLib_SOURCE_DIR="
                          #$(this-package-input "CTKAppLauncherLib"))
           (string-append "-DCTKAppLauncher_DIR="
                          #$(this-package-input "CTKAppLauncher"))
           (string-append "-DLibFFI_ROOT="
                          #$(this-package-input "LibFFI"))
           (string-append "-DLZMA_ROOT="
                          #$(this-package-input "LZMA"))
           (string-append "-Dsqlite_DIR="
                          #$(this-package-input "sqlite"))
           ;; This is the actual python source code
           (string-append "-Dpython-source_ARCHIVE="
                          #$(this-package-input "python"))
           ;; This is the cmake build system for python
           (string-append "-Dpython_SOURCE_DIR="
                          #$(this-package-input "python-cmake"))
           (string-append "-Dteem_SOURCE_DIR="
                          #$(this-package-input "teem"))
           (string-append "-Ddcmtk_SOURCE_DIR="
                          #$(this-package-input "dcmtk"))
           (string-append "-Dtbb_ARCHIVE="
                          #$(this-package-input "tbb"))
           (string-append "-Dtbb_ARCHIVE_SHA256="
                          "74861b1586d6936b620cdab6775175de46ad8b0b36fa6438135ecfb8fb5bdf98")
           (string-append "-Dtbb_VERSION="
                          "2021.5.0")
           (string-append "-DPCRE_ARCHIVE="
                          #$(this-package-input "pcre"))
           (string-append "-DPCRE_ARCHIVE_SHA512="
                          "abac4c4f9df9e61d7d7761a9c50843882611752e1df0842a54318f358c28f5953025eba2d78997d21ee690756b56cc9f1c04a5ed591dd60654cc78ba16d9ecfb")
           (string-append "-DPCRE_VERSION="
                          "8.44")
           (string-append "-DSlicer_VTK_SOURCE_DIR="
                          #$(this-package-input "vtk"))
           (string-append "-Ditk_ARCHIVE="
                          #$(this-package-input "itk"))
           (string-append "-Ditk_ARCHIVE_MD5="
                          "05ad1d4a291e49a0d3c181651db88ea1"))
         #:tests? #f
         #:phases
         #~(modify-phases %standard-phases
             (add-after 'unpack 'setenv
               (lambda _
                 (setenv "CCACHE_DIR" "/tmp/ccache")))

             ;; (add-after 'configure 'itk-remote-modules-grafting
             ;;   (lambda* (#:key inputs #:allow-other-keys)
             ;;     (let ((itk-adaptivedenoising (assoc-ref inputs "itk-adaptivedenoising")))
             ;;       (mkdir-p (string-append (getcwd) "/ITK/Modules/Remote"))
             ;;       (symlink itk-adaptivedenoising (string-append (getcwd) "/ITK/Modules/Remote/AdaptiveDenoising"))
             ;;       #t))))

             (add-after 'configure 'itk-initialize-remote-modules
               (lambda* (#:key inputs #:allow-other-keys)
                 (let ((itk-adaptivedenoising (assoc-ref inputs "itk-adaptivedenoising")))
                   (mkdir-p (string-append (getcwd) "/ITK-remotes/Modules/Remote"))
                   (symlink itk-adaptivedenoising (string-append (getcwd) "/ITK/Modules/Remote/AdaptiveDenoising"))
                   #t)))

         ))
  (home-page "https://slicer.org")
  (synopsis "Platform for Medical Image Computing")
  (inputs
   `(;; System dependencies
     ("bash" ,bash)
     ("bzip2" ,bzip2)
     ("ccache" ,ccache)
     ("cmake" ,cmake-3.30)
     ("curl" ,curl)
     ("git" ,git)
     ("openssl" ,openssl-3.0)
     ("qtbase" ,qtbase-5)
     ("qttools" ,qttools-5)
     ("qtx11extras" ,qtx11extras)
     ("qtxmlpatterns" ,qtxmlpatterns)
     ("qtmultimedia" ,qtmultimedia-5)
     ("qtsvg" ,qtsvg-5)
     ("qtwebengine" ,qtwebengine-5)
     ("qtlocation" ,qtlocation-5)
     ;; Slicer dependencies
     ("CTKAppLauncher" ,ctkapplauncher)
     ("vtkAddon"
      ,(origin
        (method git-fetch)
        (uri (git-reference (url "https://github.com/Slicer/vtkAddon")
                            (commit "3f317421da77b9f6fd48aaf40608545db4fec3e0")))
        (sha256 (base32 "1yyq8kzhqvz6d78z4fc75l5lif0qmmybg6caylpb8ibyaxlrpbqx"))))
     ("MultiVolumeExplorer"
      ,(origin
        (method git-fetch)
        (uri (git-reference
              (url "https://github.com/fedorov/MultiVolumeExplorer.git")
              (commit "36102fd0ffae409319c0a0fee71dde1df64fe9e0")))
         (sha256 (base32 "1wfxbds9qliapfg9ivzhgfiih7zzsklaczpbvps92bp3kshpja0s"))))
     ("MultiVolumeImporter"
      ,(origin
        (method git-fetch)
        (uri (git-reference
              (url "https://github.com/fedorov/MultiVolumeImporter.git")
              (commit "c8a37eb5e4f35b78ccc9287b298457a064c9d001")))
         (sha256 (base32 "177rr9rjh89sxzf4r7qpyd64z3d6r4ybsyplzfpavj6x8zr20vz1"))))
     ("SimpleFilters"
      ,(origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/SimpleITK/SlicerSimpleFilters.git")
               (commit "e82fc598bc010505e994b7ce22d953a9899a175c")))
         (sha256 (base32 "0630ppd5jmix25377fgid0v7jizdk7a7pz4nzxkh4yv2xzghlv2k"))))
     ("BRAINSTools"
      ,(origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/BRAINSia/BRAINSTools.git")
               (commit "d88a4f43e7d6c7447876d20676b538185f5edea1")))
         (sha256 (base32 "1zfgpdhjhxjw44bx51hwqn7pmnwir8bbjham18k59ykrh5jid0bj"))))
     ("CompareVolumes"
      ,(origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/pieper/CompareVolumes")
               (commit "cb755dda78f726cf9262aa4e1f75122c72a0df2f")))
         (sha256 (base32 "0w2gmh1fjnnnryvbcf6ls1g3arl0gn4jn16dcsmlqal57r7g3aji"))))
     ("LandmarkRegistration"
      ,(origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/Slicer/LandmarkRegistration")
               (commit "aa23730ae78992cf14e858fe26ccfb213ea038ab")))
         (sha256 (base32 "0d95ngja55yjr6iv2kfwqznq5n6sg1484i1q493zjzmhs3adwsyp"))))
     ("SurfaceToolbox"
      ,(origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/Slicer/SlicerSurfaceToolbox")
               (commit "e8b8f70930883adb6f4a227ad9d7339d20120f2c")))
         (sha256 (base32 "13cdpp7fa4zps129k7qfydbna7f7vy1cpg42x98lhrwpd0flmybl"))))
     ("CTKAppLauncherLib"
      ,(origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/commontk/AppLauncher.git")
               (commit "8759e03985738b8a8f3eb74ab516ba4e8ef29988")))
         (sha256 (base32 "1d74gkpnl0rn9fbkij111zzwsxir57cgirgr4pj7xlslkiplg26i"))))
     ("LibFFI"
      ,(origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/python-cmake-buildsystem/libffi.git")
               (commit "e8599d9d5a50841c11a5ff8e3438dd12f080b096")))
         (sha256 (base32 "1xa9xk2z394zk23fwshgg32ncjhs7wzscw1ccz6wgz59d786j6b4"))))
     ("LZMA"
      ,(origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/xz-mirror/xz.git")
               (commit "v5.2.5")))
         (sha256 (base32 "0k1s6xzfqs0w793f7b212szy5x2vj2jlxvc5m6fba2qni5z1any8"))))
     ("sqlite"
      ,(origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/azadkuh/sqlite-amalgamation.git")
               (commit "3.30.1")))
         (sha256 (base32 "07ajv8w46phsd4rc42sfwmamrhadnvrayd3lcrxyqzf4393gl7cp"))))
     ("python"
      ,(origin
         (method url-fetch)
         (uri "https://www.python.org/ftp/python/3.9.10/Python-3.9.10.tgz")
         (sha256 (base32 "07jp1s6gqsqqki0x72bqdfksl844v94hmxwm5im8zbnv5rqc1a8s"))))
     ("python-cmake"
      ,(origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/python-cmake-buildsystem/python-cmake-buildsystem.git")
               (commit "bb45aa7a4cfc7a5a93bc490c6158f702d1a2226f")))
         (sha256 (base32 "1rp7v920fcb7n49mqmcagbvsa4qisl2apinbfgvxnlh9d16qn2mb"))))
     ("tbb"
      ,(origin
         (method url-fetch)
         (uri "https://github.com/oneapi-src/oneTBB/releases/download/v2021.5.0/oneapi-tbb-2021.5.0-lin.tgz")
         (sha256 (base32 "166zbgxviksy2cw69yin1f5ssinyfm8pgdns1ii6p4ynhqaip1kl"))))
     ("pcre"
      ,(origin
         (method url-fetch)
         (uri "https://github.com/Slicer/SlicerBinaryDependencies/releases/download/PCRE/pcre-8.44.tar.gz")
         (sha256 (base32 "0a3pnhzhd8wipmqq9dcn3phb494hkn47pxqsf8skj3xxyd5gvjmf"))
         (patch-inputs #t)
         ;; (snippet
         ;;  #~(begin (use-modules (guix build utils))
         ;;           (substitute* "config.sub"
         ;;             (("\\/bin\\/sh")
         ;;              (string-append #+bash "/bin/sh")))))
         ))
     ("zlib"
      ,(origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/commontk/zlib.git")
               (commit "66a753054b356da85e1838a081aa94287226823e")))
         (sha256 (base32 "1pzdmall9q6jywgvicmisz0mmll8gm7i0xjg5rbirc16b7f2g0yl"))))
     ("teem"
      ,(origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/Slicer/teem.git")
               (commit "e4746083c0e1dc0c137124c41eca5d23adf73bfa")))
         (sha256 (base32 "06sls9gnvgpmb19r0isl7h9ml4xx9x44bywd37pp6jbvk3lfdli2"))))
     ("dcmtk"
      ,(origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/commontk/DCMTK.git")
               (commit "ea07125078cd097245867a71d8fba8b36fd92878")))
         (sha256 (base32 "1jj57w3zyzhfz2gbyvj812awr6ix48wf99ijpip2q8aknd1kdqwg"))))
     ;; ("itk"
     ;;  ,(origin
     ;;     (method git-fetch)
     ;;     (uri (git-reference
     ;;           (url "https://github.com/slicer/ITK.git")
     ;;           (commit "29b78d73c81d6c00c393416598d16058704c535c")))
     ;;     (sha256 (base32 "13iz2f8r5rr9xi8w2j42iidrpn18yi9mkvnw47n6d2wyrvjjl1aj"))))

     ("itk"
      ,(origin
         (method url-fetch)
         (uri "https://github.com/Slicer/ITK/archive/refs/heads/slicer-v5.4.0-2024-05-16-311b706.zip")
         (sha256 (base32 "0vvspyzy3s3rmvdb7sf3v8d7rdpm8qjn10gn2s26kwzsb7nvdn86"))))

     ("itk-adaptivedenoising"
      ,(origin
        (method git-fetch)
        (uri (git-reference
              (url "https://github.com/ntustison/ITKAdaptiveDenoising.git")
              (commit "24825c8d246e941334f47968553f0ae388851f0c")))
        (sha256 (base32 "0spcyn52z1i716qfs8rjk7p3g6p2jgns82nsgyhl6wzsmp6mpqkm"))))

     ("vtk"
      ,(origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/slicer/VTK.git")
               (commit "57bacae7e9d8613c1a5fc955028211c455f3787a")))
         (sha256 (base32 "0cjxxb0211wk8l0h9vfgzpp548bz1my3xc5k6q20fwlpp9l6vqx4"))))))
  (description
   "3D Slicer is a free, open source software for visualization, processing, segmentation, registration, and analysis of medical, biomedical, and other 3D images and meshes; and planning and navigating image-guided procedures.")
  (license slicer-license-5.8)))

slicer-desktop
