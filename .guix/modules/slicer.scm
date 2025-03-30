(define-module (slicer)
  #:use-module ((guix licenses)
                #:prefix licenses:)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages ccache)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages version-control)
  #:use-module (guix build utils)
  #:use-module (guix build glib-or-gtk-build-system)
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


;;; -------------------- SWIG ---------------------------------------
(define swig-src
  (package
    (name "swig-src")
    (version "4.0.2")
    (source
     (origin
       (method url-fetch)
       (uri "https://github.com/Slicer/SlicerBinaryDependencies/releases/download/swig/swigwin-4.0.2.zip")
       (sha256
        (base32 "0nb56i8c11sy70v8990i9j2885f87wil6lh1n2wqr0gy34pv7bfs"))))
    (build-system copy-build-system)
    ;; Include `unzip` and `bash-minimal` in inputs
    (inputs (list unzip bash-minimal))
    (arguments
     `(#:install-plan '(("." "/"))
       ;; Enable patching of shebangs
       #:patch-shebangs? #t
       #:phases (modify-phases %standard-phases
                  ;; Remove the 'build phase, as it's not needed
                  (delete 'build)
                  ;; Add a phase to substitute '/bin/sh' in scripts
                  (add-after 'unpack 'replace-hardcoded-sh
                    (lambda* (#:key inputs #:allow-other-keys)
                      (let ((bash (string-append (assoc-ref inputs "bash-minimal") "/bin/sh")))
                        ;; Replace '/bin/sh' in all relevant files
                        (substitute* (find-files "." "\\.(sh|c|h|in|am|ac|configure|make|mk)$")
                          (("/bin/sh") bash))
                        #t))))))
    (home-page "")
    (synopsis "")
    (description "")
    (license licenses:asl2.0)))

;;; -------------------- PCRE ---------------------------------------

(define pcre-src
  (package
    (name "pcre-src")
    (version "8.44")
    (source
     (origin
       (method url-fetch)
       (uri "https://github.com/Slicer/SlicerBinaryDependencies/releases/download/PCRE/pcre-8.44.tar.gz")
       (sha256
        (base32 "0a3pnhzhd8wipmqq9dcn3phb494hkn47pxqsf8skj3xxyd5gvjmf"))))
    (build-system copy-build-system)
    ;; (inputs (("bash-minimal" ,bash-minimal)))
    (arguments
     `(#:install-plan '(("." "/"))
       #:patch-shebangs? #t
       #:phases (modify-phases %standard-phases
                  (delete 'build))))
    (home-page "")
    (synopsis "")
    (description "")
    (license licenses:asl2.0)))

;;; -------------------- ITK -------------------------------------------

(define itk-growcut
  (package
    (name "itk-growcut")
    (version "0.2.1")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://github.com/InsightSoftwareConsortium/ITKGrowCut/archive/cbf93ab65117abfbf5798745117e34f22ff04728.tar.gz")
       (sha256
        (base32 "0is0a2lic6r3d2h4md7csmlbpphfwgqkjmwlh7yvwfbyy1mdngbd"))))
    (build-system copy-build-system)
    (arguments

     `(#:install-plan '(("." "/"))
       #:phases (modify-phases %standard-phases
                  (delete 'build))))
    (home-page "https://github.com/InsightSoftwareConsortium/ITKGrowCut")
    (synopsis "ITK GrowCut segmentation module")
    (description "This package provides the ITK GrowCut segmentation module.")
    (license licenses:asl2.0)))

(define itk-mghimageio
  (package
    (name "itk-mghimageio")
    (version "5.1.0")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://github.com/InsightSoftwareConsortium/ITKMGHImageIO/archive/0adac35fa22945c7a5f3a63dd8d01454577c24d3.tar.gz")
       (sha256
        (base32 "10b3qzxwk2jq17dbcihfj6l2arr27wa6z7p9pvj7jjxfp512khqy"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan '(("." "/"))
       #:phases (modify-phases %standard-phases
                  (delete 'build))))
    (home-page "https://github.com/InsightSoftwareConsortium/ITKMGHImageIO")
    (synopsis "ITK IO for storing MGH images")
    (description "ITK IO for images stored in mgh, mgz and mgh.gz formats.")
    (license licenses:cc-by4.0)))

(define itk-ioscanco
  (package
    (name "itk-ioscanco")
    (version "5.1.0")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://github.com/KitwareMedical/ITKIOScanco/archive/12fc12b01a964ccbd30bc8743f4e6cabaa2dcd5e.tar.gz")
       (sha256
        (base32 "1fv5qr8jax820rabn1vrv7bjxziwk0lwmcvc5mq86q2kclnjlyz4"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan '(("." "/"))
       #:phases (modify-phases %standard-phases
                  (delete 'build))))
    (home-page "https://itk-io-scanco-app.on.fleek.co/")
    (synopsis "ITK Image IO for Scanco MicroCT .ISQ files")
    (description "ITK Image IO for Scanco MicroCT .ISQ files")
    (license licenses:asl2.0)))

(define itk-morphologicalcontourinterpolation
  (package
    (name "itk-morphologicalcontourinterpolation")
    (version "5.1.0")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://github.com/KitwareMedical/ITKMorphologicalContourInterpolation/archive/439e40c41ff2676126f5572722e7b2a46a41e776.tar.gz")
       (sha256
        (base32 "07s260k29gvra5wnxjn19wr3cbd6rdvd9pcnkawis0c7ji33g0lm"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan '(("." "/"))
       #:phases (modify-phases %standard-phases
                  (delete 'build))))
    (home-page "https://insight-journal.org/browse/publication/977")
    (synopsis
     "An ITK-based implementation of morphological contour interpolation")
    (description
     "An ITK-based implementation of morphological contour interpolation")
    (license licenses:asl2.0)))

(define itk-adaptivedenoising
  (package
    (name "itk-adaptivedenoising")
    (version "5.1.0")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://github.com/ntustison/ITKAdaptiveDenoising/archive/012ba8882167b64405f7cefc489655f8395093ea.tar.gz")
       (sha256
        (base32 "0mmxx2csrn67a9b6bhixwna7kgphijwz20312b0qwlriw54c61r5"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan '(("." "/"))
       #:phases (modify-phases %standard-phases
                  (delete 'build))))
    (home-page "https://github.com/ntustison/ITKAdaptiveDenoising")
    (synopsis "ITK IO for storing MGH images")
    (description "ITK IO for images stored in mgh, mgz and mgh.gz formats.")
    (license licenses:asl2.0)))

(define-public itk-src
  (package
    (name "itk-src")
    (version "5.4.0")
    (source
     (origin
       (method url-fetch)
       (uri "https://github.com/Slicer/ITK/archive/29b78d73c81d6c00c393416598d16058704c535c.tar.gz")
       (sha256
        (base32 "1cqy2rzcskfjaszww4isp6g2mg4viqcp7qacfvrc97pq1qvrs5lb"))))
    (build-system copy-build-system)
    (inputs
     (list itk-adaptivedenoising
           itk-growcut
           itk-mghimageio
           itk-ioscanco
           itk-morphologicalcontourinterpolation
           itk-adaptivedenoising))
    (arguments
     `(#:install-plan '(("." "/"))
       #:phases (modify-phases %standard-phases
                  (add-before 'install 'modules-symlink
                    (lambda* (#:key inputs outputs #:allow-other-keys)
                      (symlink (assoc-ref inputs "itk-growcut")
                               "Modules/Remote/ITKGrowCut")
                      (symlink (assoc-ref inputs "itk-mghimageio")
                               "Modules/Remote/ITKMGHIO")
                      (symlink (assoc-ref inputs "itk-adaptivedenoising")
                               "Modules/Remote/ITKAdaptiveDenoising")
                      (symlink (assoc-ref inputs "itk-ioscanco")
                               "Modules/Remote/ITKIOScanco")
                      (symlink (assoc-ref inputs "itk-morphologicalcontourinterpolation")
                               "Modules/Remote/ITKMorphologicalContourInterpolation")))
                  (delete 'build))))
    (home-page "https://github.com/Slicer/itk")
    (synopsis "The Insight Toolkit")
    (description "Image segmentation and registration toolkit")
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
       ("ccache" ,ccache)
       ("cmake" ,cmake-3.30)
       ("openssl" ,openssl)
       ("qtbase-5" ,qtbase-5)
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
       ;;libzma
       ("lzma-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/xz-mirror/xz/archive/refs/tags/v5.2.5.tar.gz")
           (sha256
            (base32 "12n799mc2fwhbgbcqhh15bvgbvwmf4r2j1c10831mp8kkxi8jaqd"))))
       ;;sqlite
       ("sqlite-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/azadkuh/sqlite-amalgamation/archive/180e629393cb4ff7c635db69941baee1487ec7b4.tar.gz")
           (file-name "sqlite-3.30.1.tar.gz")
           (sha256
            (base32 "0h84bdbgk54xm6q118ivwmpywrfg7njb80gq8yp3mhpf7rx059r8"))))
       ;;python
       ("python-src"
        ,(origin
           (method url-fetch)
           (uri "https://www.python.org/ftp/python/3.9.10/Python-3.9.10.tgz")
           (file-name "Python-3.9.10.tar.gz")
           (sha256
            (base32 "07jp1s6gqsqqki0x72bqdfksl844v94hmxwm5im8zbnv5rqc1a8s"))))
       ;;python
       ("python-cmake-build-system-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/python-cmake-buildsystem/python-cmake-buildsystem/archive/48aee1262ddb7f1fbc6267352880f5a446420bb7.tar.gz")
           (sha256
            (base32 "0grm31985xmy5ywhgb3sv5g99anvqp5kp135my9rpza33ky6a41g"))))
       ;;tbb
       ("tbb-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/uxlfoundation/oneTBB/releases/download/v2021.5.0/oneapi-tbb-2021.5.0-lin.tgz")
           (file-name "oneapi-tbb-2021.5.0-lin.tar.gz")
           (sha256
            (base32 "166zbgxviksy2cw69yin1f5ssinyfm8pgdns1ii6p4ynhqaip1kl"))))
       ;;vtk
       ("vtk-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/Slicer/VTK/archive/492821449a5f2a9a1f5c73c3c6dd4389f1059d66.tar.gz")
           (sha256
            (base32 "08fg11i5gkbbzp1006parn4a8hhy2xggybs9d1n2p6zc8dfgwgyw"))))
       ;;pcre
       ("pcre-src" ,pcre-src)
       ;;pcre
       ("swig-src" ,swig-src)
       ;;teem
       ("teem-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/Slicer/teem/archive/e4746083c0e1dc0c137124c41eca5d23adf73bfa.tar.gz")
           (sha256
            (base32 "0y8wwzkflj6v5nx0v8cgzryqlxii0px3mcgb3bff1nhyr5zf9yp1"))))
       ;;dcmtk
       ("dcmtk-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/commontk/DCMTK/archive/ea07125078cd097245867a71d8fba8b36fd92878.tar.gz")
           (sha256
            (base32 "0sgz21z308w355any5m62h1x76ld8hvf2lcl274sa7c0xwn2av5z"))))
       ;;itk
       ("itk-src" ,itk-src)
       ;;ctk
       ("ctk-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/commontk/CTK/archive/82cae5781621845486bad2697aed095f04cfbe76.tar.gz")
           (sha256
            (base32 "1g2jv4hjimf4baqbmpmc29ara2f8gk8604g1v8k243x882f0ls9z"))))
       ;;slicerexecutionmodel
       ("slicerexecutionmodel-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/Slicer/SlicerExecutionModel/archive/91b921bd5977c3384916ba4b03705d87b26067f7.tar.gz")
           (sha256
            (base32 "10k1m3impplv9hwhxx06wfmvlx9h54avhibv4id1pjlqjn5gjjza"))))
       ;;simpleitk
       ("simpleitk-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/Slicer/SimpleITK/archive/441c59aafaa179214d60b77f61d0aa12fd32bdfd.tar.gz")
           (sha256
            (base32 "04j1k46w6kvgk49yxbpdp496c2h45kl4wk8mww077dp62q9dcjpy"))))
       ;; libarchive
       ("libarchive-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/Slicer/libarchive/archive/14ec55f065e31fbbca23d3d96d43e07f21c6fb6d.tar.gz")
           (sha256
            (base32 "1l8a6x0dmvl1q664dzg1f3m92mhbwk8qyf92i4ab8yj720knazvv"))))
       ;; rapidjson
       ("rapidjson-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/Tencent/rapidjson/archive/973dc9c06dcd3d035ebd039cfb9ea457721ec213.tar.gz")
           (sha256
            (base32 "1xy6lxgd7xy2lcavsqh86q905jk9lsrqrlr1nxp214yl4clfbjfh"))))
       ;; jsoncpp
       ("jsoncpp-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/Slicer/jsoncpp/archive/73b8e172d6615251ef851d883ef02f163e7075b2.tar.gz")
           (sha256
            (base32 "1ydgfji75y15xnw9jh6zdxdb7cfrfrqv36zcwc7ili4hgvyhvi37"))))
       ;; qrestapi
       ("qrestapi-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/commontk/qRestAPI/archive/88c02c5d90169dfe065fa068969e59ada314d3cb.tar.gz")
           (sha256
            (base32 "0jfnja3frcm4vkibi1vygdh7f4dmhqxni43bbb3rmlcl6jlyaibl"))))
       ;; ------------SimpleITK dependencies--------------
       ;; lua
       ("lua-src"
        ,(origin
           (method url-fetch)
           (uri "https://data.kitware.com/api/v1/file/hashsum/sha512/d90c6903355ee1309cb0d92a8a024522ff049091a117ea21efb585b5de35776191cd67d17a65b18c2f9d374795b7c944f047576f0e3fe818d094b26f0e4845c5/download")
           (file-name "d90c6903355ee1309cb0d92a8a024522ff049091a117ea21efb585b5de35776191cd67d17a65b18c2f9d374795b7c944f047576f0e3fe818d094b26f0e4845c5")
           (sha256
            (base32 "125dncwz8syhxk034m4fpahq7vsprfnwdqfxlffbb83arfws2pkx"))))

       ;; -------------Python PyPI dependencies--------------
       ;; python-setuptools
       ("python-setuptools-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/de/88/70c5767a0e43eb4451c2200f07d042a4bcd7639276003a9c54a68cfcc1f8/setuptools-70.0.0-py3-none-any.whl")
           (file-name "setuptools-70.0.0-py3-none-any.whl")
           (sha256
            (base32 "1m0sgf0vbmrpsynk470d11f6n17ixs1d5gh75k6iplfjx3ragyjl"))))
       ;; python-pip
       ("python-pip-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/8a/6a/19e9fe04fca059ccf770861c7d5721ab4c2aebc539889e97c7977528a53b/pip-24.0-py3-none-any.whl")
           (file-name "pip-24.0-py3-none-any.whl")
           (sha256
            (base32 "1p39gkxf6v0my4wwri8hx56i5zsj07n1p5j6a8kd4rb82qd043ds"))))
       ;; python-wheel
       ("python-wheel-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/7d/cd/d7460c9a869b16c3dd4e1e403cce337df165368c71d6af229a74699622ce/wheel-0.43.0-py3-none-any.whl")
           (file-name "wheel-0.43.0-py3-none-any.whl")
           (sha256
            (base32 "10fsfxrmn7ybimdswhzmzivi9kv7kffy0bzpp73309hlbx071iam"))))
       ;; python-certifi
       ("python-certifi-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/ba/06/a07f096c664aeb9f01624f858c3add0a4e913d6c96257acb4fce61e7de14/certifi-2024.2.2-py3-none-any.whl")
           (file-name "certifi-2024.2.2-py3-none-any.whl")
           (sha256
            (base32 "1lfds5aaf96aqr9gcmadx88s011vb4mywvhhyrlg62b1nw3kqf6w"))))
       ;; python-idna
       ("python-idna-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/e5/3e/741d8c82801c347547f8a2a06aa57dbb1992be9e948df2ea0eda2c8b79e8/idna-3.7-py3-none-any.whl")
           (file-name "idna-3.7-py3-none-any.whl")
           (sha256
            (base32 "180sfq3qsycfxn1zc9w4gp4lr44adpx8p2d1sf939m5dg3yf3zl2"))))
       ;; python-charset-normalizer
       ("python-charset-normalizer-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/98/69/5d8751b4b670d623aa7a47bef061d69c279e9f922f6705147983aa76c3ce/charset_normalizer-3.3.2-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl")
           (file-name "charset_normalizer-3.3.2-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl")
           (sha256
            (base32 "15mph3i2bb5v9jvm41mk2mnrxdp9ns5hi3blvvd824l2qzgcqqdj"))))
       ;; python-urllib3
       ("python-urllib3-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/a2/73/a68704750a7679d0b6d3ad7aa8d4da8e14e151ae82e6fee774e6e0d05ec8/urllib3-2.2.1-py3-none-any.whl")
           (file-name "urllib3-2.2.1-py3-none-any.whl")
           (sha256
            (base32 "17gsqhr25vrbl1h9mxbgnmqnwlc062vl5zwb29vp0ika57n202s5"))))
       ;; python-requests
       ("python-requests-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/f9/9b/335f9764261e915ed497fcdeb11df5dfd6f7bf257d4a6a2a686d80da4d54/requests-2.32.3-py3-none-any.whl")
           (file-name "requests-2.32.3-py3-none-any.whl")
           (sha256
            (base32 "1inwsrhx0m16q0wa1z6dfm8i8xkrfns73xm25arcwwy70gz1qxkh"))))
       ;; python-numpy
       ("python-numpy-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/54/30/c2a907b9443cf42b90c17ad10c1e8fa801975f01cb9764f3f8eb8aea638b/numpy-1.26.4-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl")
           (file-name "numpy-1.26.4-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl")
           (sha256
            (base32 "1lxw9zbdzrhv5h61pdk1b4xqrsaif17z6gi7285xlq0ahi520w7q"))))
       ;; python-scipy
       ("python-scipy-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/35/f5/d0ad1a96f80962ba65e2ce1de6a1e59edecd1f0a7b55990ed208848012e0/scipy-1.13.1-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl")
           (file-name "scipy-1.13.1-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl")
           (sha256
            (base32 "0kdsars7024r9yh55bkp0i104iwcj2zjw4iycs77zfl5y7f9hzk3"))))
       ;; python-pydicom
       ("python-pydicom-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/35/2a/8c0f6fe243e6b6793868c6834203a44cc8f3f25abad780e1c7b21e15594d/pydicom-2.4.4-py3-none-any.whl")
           (file-name "pydicom-2.4.4-py3-none-any.whl")
           (sha256
            (base32 "0hkwpnqdscci8mwnq8nnq5md1r1ki0lq8i1qlrxfansjg2dy3y7r"))))
       ;; python-six
       ("python-six-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/d9/5a/e7c31adbe875f2abbb91bd84cf2dc52d792b5a01506781dbcf25c91daf11/six-1.16.0-py2.py3-none-any.whl")
           (file-name "six-1.16.0-py2.py3-none-any.whl")
           (sha256
            (base32 "0m02dsi8lvrjf4bi20ab6lm7rr6krz7pg6lzk3xjs2l9hqfjzfwa"))))
       ;; python-pillow
       ("python-pillow-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/15/5c/2e16159554296a10017bfad367d495909f863abf7ea506f24fff8e6799b3/pillow-10.3.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl")
           (file-name "pillow-10.3.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl")
           (sha256
            (base32 "0xckgf054b7q9anj6cawsppcl6y7ildfgxinhg9p6lcl21d080ii"))))
       ;; python-retrying
       ("python-retrying-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/8f/04/9e36f28be4c0532c0e9207ff9dc01fb13a2b0eb036476a213b0000837d0e/retrying-1.3.4-py3-none-any.whl")
           (file-name "retrying-1.3.4-py3-none-any.whl")
           (sha256
            (base32 "0dbvycx1ih0d4jr822vm7gdqbzgyg3k9skilyc7mw4p1p0yd9i4c"))))
       ;; python-dicomweb-client
       ("python-dicomweb-client-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/e2/c4/7d175d42360052bdddabef3c11a10d54031314c1e5abc5711681c6cd2838/dicomweb_client-0.59.1-py3-none-any.whl")
           (file-name "dicomweb_client-0.59.1-py3-none-any.whl")
           (sha256
            (base32 "0y8dsbdyw1m5f3zjp2dpqmxbmnf69y4ji2yg84c6kcyy3dggjjmd"))))
       ;; python-chardet
       ("python-chardet-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/38/6f/f5fbc992a329ee4e0f288c1fe0e2ad9485ed064cac731ed2fe47dcc38cbf/chardet-5.2.0-py3-none-any.whl")
           (file-name "chardet-5.2.0-py3-none-any.whl")
           (sha256
            (base32 "0w19r0s9wil8qyr45dyl0rpnwjx05r4i4ybvzq2h384hd125kkz1"))))
       ;; python-couchdb
       ("python-couchdb-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/ff/35/6660f7526c5d509b13264b27642de73754bd3d0addf56b175601c8b951e1/CouchDB-1.2-py2.py3-none-any.whl")
           (file-name "CouchDB-1.2-py2.py3-none-any.whl")
           (sha256
            (base32 "1laih7l9yjdixskw85y0prablp6nljwj91rffd3877y4b48qm8hk"))))
       ;; python-gitdb
       ("python-gitdb-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/fd/5b/8f0c4a5bb9fd491c277c21eff7ccae71b47d43c4446c9d0c6cff2fe8c2c4/gitdb-4.0.11-py3-none-any.whl")
           (file-name "gitdb-4.0.11-py3-none-any.whl")
           (sha256
            (base32 "196z78fwy3gyjqb018yg18al13h35l7a1kms9i2dzs1fvmyl18w1"))))
       ;; python-smmap
       ("python-smmap-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/a7/a5/10f97f73544edcdef54409f1d839f6049a0d79df68adbc1ceb24d1aaca42/smmap-5.0.1-py3-none-any.whl")
           (file-name "smmap-5.0.1-py3-none-any.whl")
           (sha256
            (base32 "1nk95crslxdny5gbgnraryw9x3cwn56pnbd66ilp0gprln7ndn76"))))
       ;; python-cryptography
       ("python-cryptography-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/79/fd/4525835d3e42e2db30169d42215ce74762f447fcbf01ed02f74f59bd74cb/cryptography-42.0.7-cp39-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl")
           (file-name "cryptography-42.0.7-cp39-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl")
           (sha256
            (base32 "119py4af27q7jfbj7wi9mknxmjdxrn4a4y1afibwvd4qvfakfmhd"))))
       ;; python-PyJWT
       ("python-PyJWT-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/2b/4f/e04a8067c7c96c364cef7ef73906504e2f40d690811c021e1a1901473a19/PyJWT-2.8.0-py3-none-any.whl")
           (file-name "PyJWT-2.8.0-py3-none-any.whl")
           (sha256
            (base32 "0823w2rjmh7xf16m7xmg2x794aglj6d1d4iipfjjsk645hwpq4jr"))))
       ;; python-wrapt
       ("python-wrapt-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/b1/e7/459a8a4f40f2fa65eb73cb3f339e6d152957932516d18d0e996c7ae2d7ae/wrapt-1.16.0-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl")
           (file-name "wrapt-1.16.0-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl")
           (sha256
            (base32 "12lv1axsmz6l8741npqsamahq92fd57q20p5cm2ynl4wsij2a8gq"))))
       ;; python-Deprecated
       ("python-Deprecated-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/20/8d/778b7d51b981a96554f29136cd59ca7880bf58094338085bcf2a979a0e6a/Deprecated-1.2.14-py2.py3-none-any.whl")
           (file-name "Deprecated-1.2.14-py2.py3-none-any.whl")
           (sha256
            (base32 "0v26f22dg6c434dzz0q5fb2d6cp72nwbj5xvpl107aclfw4qpb3g"))))
       ;; python-pycparser
       ("python-pycparser-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/13/a3/a812df4e2dd5696d1f351d58b8fe16a405b234ad2886a0dab9183fb78109/pycparser-2.22-py3-none-any.whl")
           (file-name "pycparser-2.22-py3-none-any.whl")
           (sha256
            (base32 "1k6gk7j4s3s7fpflxhndhsyx18ak7pkdfrd5mz0spiyq7mnjnw63"))))
       ;; python-cffi
       ("python-cffi-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/ea/ac/e9e77bc385729035143e54cc8c4785bd480eaca9df17565963556b0b7a93/cffi-1.16.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl")
           (file-name "cffi-1.16.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl")
           (sha256
            (base32 "1660p3k2wsiygj11wjyldjh0drwf7jzwia60m1379iy64y8p13lg"))))
       ;; python-PyNaCl
       ("python-PyNaCl-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/ee/87/f1bb6a595f14a327e8285b9eb54d41fef76c585a0edef0a45f6fc95de125/PyNaCl-1.5.0-cp36-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_24_x86_64.whl")
           (file-name "PyNaCl-1.5.0-cp36-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_24_x86_64.whl")
           (sha256
            (base32 "0kd4zd1f389wc79kjpdfwvwi69fldmq47gn90wv037ji49x9910c"))))
       ;; python-python-dateutil
       ("python-python-dateutil-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/ec/57/56b9bcc3c9c6a792fcbaf139543cee77261f3651ca9da0c93f5c1221264b/python_dateutil-2.9.0.post0-py2.py3-none-any.whl")
           (file-name "python_dateutil-2.9.0.post0-py2.py3-none-any.whl")
           (sha256
            (base32 "09q48zvsbagfa3w87zkd2c5xl54wmb9rf2hlr20j4a5fzxxvrcm8"))))
       ;; python-typing_extensions
       ("python-typing_extensions-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/b6/53/84a859aaddfe7378a6e5820e864a2d75763e82b6fcbda1a00e92ec620bb7/typing_extensions-4.12.1-py3-none-any.whl")
           (file-name "typing_extensions-4.12.1-py3-none-any.whl")
           (sha256
            (base32 "0fi0gn1zxw4vxrzyqa3pj0mg06szwda74fa7qf4mm7h8d65va930"))))
       ;; python-PyGithub
       ("python-PyGithub-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/84/2a/f7f72a06881493eeb763c207bea69f9ee4477c78200937b22b8b79f3acf9/PyGithub-2.3.0-py3-none-any.whl")
           (file-name "PyGithub-2.3.0-py3-none-any.whl")
           (sha256
            (base32 "0gkr9rbgd43zc5vhcpjyqmxls3rgnfihsxnds867pkp3idr9kd35"))))
       ;; python-packaging
       ("python-packaging-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/49/df/1fceb2f8900f8639e278b056416d49134fb8d84c5942ffaa01ad34782422/packaging-24.0-py3-none-any.whl")
           (file-name "packaging-24.0-py3-none-any.whl")
           (sha256
            (base32 "1i8b2dw7fxz3xb94m5pcmg79d0i8rinbmirlqa2bfbzhzm9vbprd"))))
       ;; python-pyparsing
       ("python-pyparsing-whl"
        ,(origin
           (method url-fetch)
           (uri "https://files.pythonhosted.org/packages/9d/ea/6d76df31432a0e6fdf81681a895f009a4bb47b3c39036db3e1b528191d52/pyparsing-3.1.2-py3-none-any.whl")
           (file-name "pyparsing-3.1.2-py3-none-any.whl")
           (sha256
            (base32 "0hmpiw1r4wm6b8sfdjlzm6n02rpqkw3l7dhvws7pgv81328pbnzr"))))
       ;; -------------ctk dependencies--------------
       ;; pythonqt
       ("pythonqt-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/commontk/PythonQt/archive/db525aff0d8c053bddf13902107b34c93c1e3a44.tar.gz")
           (sha256
            (base32 "048lnq378hsx1afg1zdm0326r0cqyzqj29xbf50n7sfgd8mvc43i"))))
       ;; qttesting
       ("qttesting-src"
        ,(origin
           (method url-fetch)
           (uri "https://github.com/commontk/QtTesting/archive/a86bee55104f553a1cb82b9cf0b109d9f1e95dbf.tar.gz")
           (sha256
            (base32 "0kr0f34ggw8q7mhxpxgmxr6m12fdcwwqksls4hx8kp420ylicvj9"))))
       ("bash" ,bash)
       ))
    (arguments
     (list #:tests? #f
           #:phases
           #~(modify-phases %standard-phases
               ;; Set up ccache before configuration
               (add-before 'configure 'set-up-ccache
                 (lambda* (#:key inputs outputs #:allow-other-keys)
                   (let ((ccache (assoc-ref inputs "ccache"))
                         (external-ccache-dir (getenv "EXTERNAL_CCACHE_DIR")))
                     (setenv "PATH"
                             (string-append (string-append ccache "/bin") ":" (getenv "PATH")))
                     (if external-ccache-dir
                         (setenv "CCACHE_DIR" external-ccache-dir)
                         (let ((ccache-dir (string-append (getcwd) "/ccache")))
                           (setenv "CCACHE_DIR" ccache-dir)
                           (mkdir-p ccache-dir)))
                     (setenv "CCACHE_BASEDIR" (getcwd))
                     ;; Optionally set CCACHE_LOGFILE
                     (setenv "CCACHE_LOGFILE" (string-append (getcwd) "/ccache.log"))
                     #t)))
               (add-before 'configure 'copy-wheel-files
                 (lambda* (#:key inputs #:allow-other-keys)
                   (use-modules (srfi srfi-13))
                   (let ((wheel-dir (string-append (getcwd) "/wheelhouse")))
                     (mkdir-p wheel-dir)
                     (for-each
                      (lambda (input)
                        (let ((name (car input))
                              (path (cdr input)))
                          (when (string-suffix? "-whl" name)
                            ;; Get the basename without the hash prefix
                            (let* ((basename (basename path))
                                   (pos (string-index basename #\-))
                                   (new-name (if pos
                                                 (substring basename (+ pos 1))  ; Skip hash and hyphen
                                                 basename)))
                              ;; Copy the wheel file to wheelhouse/ with the correct name
                              (copy-file path (string-append wheel-dir "/" new-name))))))
                      inputs)
                     ;; Set PIP_FIND_LINKS to the wheelhouse directory, so pip can find the wheel files
                     (setenv "PIP_FIND_LINKS" wheel-dir)
                     ;; Set PIP_NO_INDEX to prevent pip from accessing the internet
                     (setenv "PIP_NO_INDEX" "true")
                     #t)))
               (replace 'install
                 (lambda* (#:key outputs #:allow-other-keys)
                   (let* ((out (assoc-ref outputs "out"))
                          (tarball "Slicer-5.8.1--linux.tar.gz")
                          (tarball-path (string-append "Slicer-build/" tarball)))
                     ;; Run cpack inside "Slicer-build" directory
                     (with-directory-excursion "Slicer-build"
                       (invoke "cpack"))
                     ;; Ensure the output directory exists
                     (mkdir-p out)
                     ;; Extract the tarball into the output directory
                     ;; Use "--no-same-owner" and "--no-same-permissions" to handle permissions correctly
                     (invoke "tar" "xzf" tarball-path
                             "--no-same-owner" "--no-same-permissions" "--strip-components=1" "-C" out))))
               (add-after 'install 'make-wrapper
                 (lambda* (#:key inputs outputs #:allow-other-keys)
                   (let* ((out (assoc-ref outputs "out"))
                          (bash (assoc-ref inputs "bash"))
                          (wrapper (string-append out "/bin/Slicer")))
                     (with-output-to-file wrapper
                       (lambda _
                         (display
                          (string-append
                           "#!" bash "/bin/sh\n\n"
                           out "/Slicer \"$@\"\n"))))
                     (chmod wrapper #o555))
                   #t)))
               ;; Save the ccache after installation
               ;; (add-after 'install 'save-ccache
               ;;   (lambda* (#:key outputs #:allow-other-keys)
               ;;     (let* ((ccache-out (assoc-ref outputs "ccache"))
               ;;            (ccache-dir (getenv "CCACHE_DIR")))
               ;;       (if (file-exists? ccache-dir)
               ;;           (begin
               ;;             (mkdir-p ccache-out)
               ;;             (copy-recursively ccache-dir ccache-out))
               ;;           (format #t "Warning: ccache directory ~a does not exist~%" ccache-dir))
               ;;       #t))))

           ;; #~(modify-phases %standard-phases
           ;;     (replace 'install
           ;;       (lambda* (#:key outputs #:allow-other-keys)
           ;;         (let* ((out (assoc-ref outputs "out")))
           ;;           (chdir "Slicer-build")
           ;;           (invoke "cpack")
           ;;           (invoke "tar" "xvzf" "Slicer-5.8.1--linux.tar.gz" "-C" out)))))

           ;;This is for debug purposes and allows to build a specific target
           ;; (replace 'build
           ;;   (lambda* (#:key out #:allow-other-keys)
           ;;     (apply invoke "make" "Swig"
           ;;            (format #f "-j~a" (parallel-job-count))
           ;;            make-flags))))
           #:configure-flags
           #~(list "-DBUILD_TESTING:BOOL=OFF"
                   "-DSlicer_DISABLE_HTTPS_CHECK:BOOL=ON"
                   "-DSlicer_USE_SYSTEM_OpenSSL:BOOL=ON"
                   "-DSlicer_USE_SimpleITK:BOOL=OFF"
                   "-DSlicer_FORCED_REVISION:STRING=12345"
                   "-DSlicer_FORCED_WC_LAST_CHANGED_DATE:STRING=2025-02-20"
                   "-DSlicer_BUILD_I18N_SUPPORT:BOOL=OFF"
                   "-DSlicer_BUILD_MULTIVOLUME_SUPPORT:BOOL=OFF"
                   "-DSlicer_USE_SYSTEM_QT:BOOL=ON"
                   (string-append
                    "-DQtDesigner_PATH:FILEPATH="
                    #$(this-package-input "qttools-5")
                    "/bin/designer")
                   (string-append
                    "-DQt_Resources_PATH:PATH="
                    #$(this-package-input "qtwebengine-5")
                    "/share/qt5/resources")
                   (string-append
                    "-DQtWebEngineProcess_PATH:FILEPATH="
                    #$(this-package-input "qtwebengine-5")
                    "/lib/qt5/libexec/QtWebEngineProcess")
                   (string-append
                    "-DSlicer_CONFIG_SHELL:FILEPATH="
                    #$(this-package-input "bash")
                    "/bin/bash")
                   ;; vtkAddon
                   (string-append
                    "-DvtkAddon_ARCHIVE:FILEPATH="
                    #$(this-package-input "vtkaddon-src"))
                   (string-append
                    "-DvtkAddon_ARCHIVE_HASH:STRING="
                    "MD5=8469bc071fefd247dbcf39de74657704")
                   ;; MultiVolumeExplorer
                   (string-append
                    "-DMultiVolumeExplorer_ARCHIVE:FILEPATH="
                    #$(this-package-input "multivolumeexplorer-src"))
                   (string-append
                    "-DMultiVolumeExplorer_ARCHIVE_HASH:STRING="
                    "MD5=f7ad3659fe864f745fe885967ae4a443")
                   ;; MultiVolumeImporter
                   (string-append
                    "-DMultiVolumeImporter_ARCHIVE:FILEPATH="
                    #$(this-package-input "multivolumeexplorer-src"))
                   (string-append
                    "-DMultiVolumeImporter_ARCHIVE_HASH:STRING="
                    "MD5=f7ad3659fe864f745fe885967ae4a443")
                   ;; SimpleFilters
                   (string-append
                    "-DSimpleFilters_ARCHIVE:FILEPATH="
                    #$(this-package-input "simplefilters-src"))
                   (string-append
                    "-DSimpleFilters_ARCHIVE_HASH:STRING="
                    "MD5=64937b5b3e9bf2c8a24607115baab732")
                   ;; BRAINSTools
                   (string-append
                    "-DBRAINSTools_ARCHIVE:FILEPATH="
                    #$(this-package-input "brainstools-src"))
                   (string-append
                    "-DBRAINSTools_ARCHIVE_HASH:STRING="
                    "MD5=d7ac725d5a9673816d2428e68d7b318d")
                   ;; CompareVolumes
                   (string-append
                    "-DCompareVolumes_ARCHIVE:FILEPATH="
                    #$(this-package-input "comparevolumes-src"))
                   (string-append
                    "-DCompareVolumes_ARCHIVE_HASH:STRING="
                    "MD5=cd5296f50fee721ae5147d6f9be9305c")
                   ;; LandmarkRegistration
                   (string-append
                    "-DLandmarkRegistration_ARCHIVE:FILEPATH="
                    #$(this-package-input "landmarkregistration-src"))
                   (string-append
                    "-DLandmarkRegistration_ARCHIVE_HASH:STRING="
                    "MD5=20242072f956c1edb26905fd71683754")
                   ;; SurfaceToolbox
                   (string-append
                    "-DSurfaceToolbox_ARCHIVE:FILEPATH="
                    #$(this-package-input "surfacetoolbox-src"))
                   (string-append
                    "-DSurfaceToolbox_ARCHIVE_HASH:STRING="
                    "MD5=8c9aa3dca36e390431325af9778a7286")
                   ;; zlib
                   (string-append
                    "-Dzlib_ARCHIVE:FILEPATH="
                    #$(this-package-input "zlib-src"))
                   (string-append
                    "-Dzlib_ARCHIVE_HASH:STRING="
                    "MD5=9f9ab02eb259dc3d81895aa0fa534620")
                   ;; curl
                   (string-append
                    "-Dcurl_ARCHIVE:FILEPATH="
                    #$(this-package-input "curl-src"))
                   (string-append
                    "-Dcurl_ARCHIVE_HASH:STRING="
                    "MD5=8330412e835ac88200e0412f59475203")
                   ;; ctkapplauncherlib
                   (string-append
                    "-DCTKAppLauncherLib_ARCHIVE:FILEPATH="
                    #$(this-package-input "ctkapplauncherlib-src"))
                   (string-append
                    "-DCTKAppLauncherLib_ARCHIVE_HASH:STRING="
                    "MD5=c2fb456dad59c31559c9b345f0971efb")
                   ;; ctkapplauncher
                   (string-append
                    "-DCTKAppLauncher_DIR:PATH="
                    #$(this-package-input "ctkapplauncher"))
                   ;;bzip2
                   (string-append
                    "-Dbzip2_ARCHIVE:FILEPATH="
                    #$(this-package-input "bzip2-src"))
                   (string-append
                    "-Dbzip2_ARCHIVE_HASH:STRING="
                    "MD5=f6c635378f9687eadb0daf58ce609e98")
                   ;;libffi
                   (string-append
                    "-DLibFFI_ARCHIVE:FILEPATH="
                    #$(this-package-input "libffi-src"))
                   (string-append
                    "-DLibFFI_ARCHIVE_HASH:STRING="
                    "MD5=ca0dc8674a5d7fa9dbc96a762fcc6d20")
                   ;;lzma
                   (string-append
                    "-DLZMA_ARCHIVE:FILEPATH="
                    #$(this-package-input "lzma-src"))
                   (string-append
                    "-DLZMA_ARCHIVE_HASH:STRING="
                    "MD5=1380da72b651c2e96f76958e29c1fa68")
                   ;;sqlite
                   (string-append
                    "-Dsqlite_ARCHIVE:FILEPATH="
                    #$(this-package-input "sqlite-src"))
                   (string-append
                    "-Dsqlite_ARCHIVE_HASH:STRING="
                    "MD5=b9e39e59f549ccd0a29fe08b74984520")
                   ;;python
                   (string-append
                    "-Dpython_ARCHIVE:FILEPATH="
                    #$(this-package-input "python-src"))
                   (string-append
                    "-Dpython_ARCHIVE_HASH:STRING="
                    "MD5=1440acb71471e2394befdb30b1a958d1")
                   ;;python-cmake-build-system
                   (string-append
                    "-DSlicer_python_ARCHIVE:FILEPATH="
                    #$(this-package-input "python-cmake-build-system-src"))
                   (string-append
                    "-DSlicer_python_ARCHIVE_HASH:STRING="
                    "MD5=32a4f71a785a8410c57cfde0f42f5cdd")
                   ;;tbb
                   (string-append
                    "-Dtbb_ARCHIVE:FILEPATH="
                    #$(this-package-input "tbb-src"))
                   (string-append
                    "-Dtbb_ARCHIVE_HASH:STRING="
                    "SHA256=74861b1586d6936b620cdab6775175de46ad8b0b36fa6438135ecfb8fb5bdf98")
                   ;;vtk
                   (string-append
                    "-DVTK_ARCHIVE:FILEPATH="
                    #$(this-package-input "vtk-src"))
                   (string-append
                    "-DVTK_ARCHIVE_HASH:STRING="
                    "MD5=330f794a753744d8c9dd4126d11ade52")
                   ;;pcre
                   (string-append
                    "-DPCRE_SOURCE_DIR:FILEPATH="
                    #$(this-package-input "pcre-src"))
                   ;;swig
                   (string-append
                    "-DSwig_SOURCE_DIR:FILEPATH="
                    #$(this-package-input "swig-src"))
                   ;;teem
                   (string-append
                    "-Dteem_ARCHIVE:FILEPATH="
                    #$(this-package-input "teem-src"))
                   (string-append
                    "-Dteem_ARCHIVE_HASH:STRING="
                    "MD5=2ec45169a198b7376f16868776dcccb4")
                   ;;DCMTK
                   (string-append
                    "-DDCMTK_ARCHIVE:FILEPATH="
                    #$(this-package-input "dcmtk-src"))
                   (string-append
                    "-DDCMTK_ARCHIVE_HASH:STRING="
                    "MD5=a066f789d6d0623c90dfc9e52dfc13d9")
                   ;;itk
                   (string-append
                    "-DITK_SOURCE_DIR:FILEPATH="
                    #$(this-package-input "itk-src"))
                   ;;ctk
                   (string-append
                    "-DCTK_ARCHIVE:FILEPATH="
                    #$(this-package-input "ctk-src"))
                   (string-append
                    "-DCTK_ARCHIVE_HASH:STRING="
                    "MD5=d0aa576350076b7bc3a3e280f518b795")
                   ;;slicerexecutionmodel
                   (string-append
                    "-DSlicerExecutionModel_ARCHIVE:FILEPATH="
                    #$(this-package-input "slicerexecutionmodel-src"))
                   (string-append
                    "-DSlicerExecutionModel_ARCHIVE_HASH:STRING="
                    "MD5=b05b7ce724768bb3812bd31e0d6e79f7")
                   ;;simpleitk
                   (string-append
                    "-DSimpleITK_ARCHIVE:FILEPATH="
                    #$(this-package-input "simpleitk-src"))
                   (string-append
                    "-DSimpleITK_ARCHIVE_HASH:STRING="
                    "MD5=6cec67fafa4933b06a2008a1c43fa9ab")
                   ;;simpleitk external data (dependencies)
                                        ;lua
                   (string-append
                    "-DSimpleITK_ExternalData_URL_TEMPLATES="
                    "file://"
                    (car (string-split #$(this-package-input "lua-src") #\-))
                    "-%(hash)")
                   ;;PythonQt
                   (string-append
                    "-DPythonQt_ARCHIVE:FILEPATH="
                    #$(this-package-input "pythonqt-src"))
                   (string-append
                    "-DPythonQt_ARCHIVE_HASH:STRING="
                    "MD5=a95d70bd0d03f2b15dfa6e3d62ac6b5c")
                   ;;Qttesting
                   (string-append
                    "-DQtTesting_ARCHIVE:FILEPATH="
                    #$(this-package-input "qttesting-src"))
                   (string-append
                    "-DQtTesting_ARCHIVE_HASH:STRING="
                    "MD5=77cff832b309a622cd3c53ecbaaab7d7")
                   ;;Qttesting
                   (string-append
                    "-DLibArchive_ARCHIVE:FILEPATH="
                    #$(this-package-input "libarchive-src"))
                   (string-append
                    "-DLibArchive_ARCHIVE_HASH:STRING="
                    "MD5=7aff310dfcd799ee0bd2cd0099244ddd")
                   ;;RapidJSON
                   (string-append
                    "-DRapidJSON_ARCHIVE:FILEPATH="
                    #$(this-package-input "rapidjson-src"))
                   (string-append
                    "-DRapidJSON_ARCHIVE_HASH:STRING="
                    "MD5=519e36730797be8fb8d4374f4d044733")
                   ;;Jsoncpp
                   (string-append
                    "-DJsonCpp_ARCHIVE:FILEPATH="
                    #$(this-package-input "jsoncpp-src"))
                   (string-append
                    "-DJsonCpp_ARCHIVE_HASH:STRING="
                    "MD5=2417e041c12f31704066b78167a6f17d")
                   ;;Qrestapi
                   (string-append
                    "-DqRestAPI_ARCHIVE:FILEPATH="
                    #$(this-package-input "qrestapi-src"))
                   (string-append
                    "-DqRestAPI_ARCHIVE_HASH:STRING="
                    "MD5=a99b54be5b6f408e31c1a6d1f595fb95")
                   ;;Python-Setuptools
                   (string-append
                    "-Dpython-setuptools_ARCHIVE:FILEPATH="
                    (string-append (getcwd) "/source/wheelhouse/setuptools-70.0.0-py3-none-any.whl"))
                   (string-append
                    "-Dpython-setuptools_ARCHIVE_HASH:STRING="
                    "sha256:54faa7f2e8d2d11bcd2c07bed282eef1046b5c080d1c32add737d7b5817b1ad4")
                   ;;Python-Pip
                   (string-append
                    "-Dpython-pip_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/pip-24.0-py3-none-any.whl"))
                   (string-append
                    "-Dpython-pip_ARCHIVE_HASH:STRING="
                    "sha256:ba0d021a166865d2265246961bec0152ff124de910c5cc39f1156ce3fa7c69dc")
                   ;;Python-wheel
                   (string-append
                    "-Dpython-wheel_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/wheel-0.43.0-py3-none-any.whl"))
                   (string-append
                    "-Dpython-wheel_ARCHIVE_HASH:STRING="
                    "sha256:55c570405f142630c6b9f72fe09d9b67cf1477fcf543ae5b8dcb1f5b7377da81")
                   ;;Python-certifi
                   (string-append
                    "-Dpython-certifi_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/certifi-2024.2.2-py3-none-any.whl"))
                   (string-append
                    "-Dpython-certifi_ARCHIVE_HASH:STRING="
                    "sha256:dc383c07b76109f368f6106eee2b593b04a011ea4d55f652c6ca24a754d1cdd1")
                   ;;Python-idna
                   (string-append
                    "-Dpython-idna_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/idna-3.7-py3-none-any.whl"))
                   (string-append
                    "-Dpython-idna_ARCHIVE_HASH:STRING="
                    "sha256:82fee1fc78add43492d3a1898bfa6d8a904cc97d8427f683ed8e798d07761aa0")
                   ;;Python-charset-normalizer
                   (string-append
                    "-Dpython-charset-normalizer_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/charset_normalizer-3.3.2-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"))
                   (string-append
                    "-Dpython-charset-normalizer_ARCHIVE_HASH:STRING="
                    "sha256:b261ccdec7821281dade748d088bb6e9b69e6d15b30652b74cbbac25e280b796")
                   ;;Python-urllib3
                   (string-append
                    "-Dpython-urllib3_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/urllib3-2.2.1-py3-none-any.whl"))
                   (string-append
                    "-Dpython-urllib3_ARCHIVE_HASH:STRING="
                    "sha256:450b20ec296a467077128bff42b73080516e71b56ff59a60a02bef2232c4fa9d")
                   ;;Python-requests
                   (string-append
                    "-Dpython-requests_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/requests-2.32.3-py3-none-any.whl"))
                   (string-append
                    "-Dpython-requests_ARCHIVE_HASH:STRING="
                    "sha256:70761cfe03c773ceb22aa2f671b4757976145175cdfca038c02654d061d6dcc6")
                   ;;Python-numpy
                   (string-append
                    "-Dpython-numpy_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/numpy-1.26.4-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"))
                   (string-append
                    "-Dpython-numpy_ARCHIVE_HASH:STRING="
                    "sha256:f870204a840a60da0b12273ef34f7051e98c3b5961b61b0c2c1be6dfd64fbcd3")
                   ;;Python-scipy
                   (string-append
                    "-Dpython-scipy_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/scipy-1.13.1-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"))
                   (string-append
                    "-Dpython-scipy_ARCHIVE_HASH:STRING="
                    "sha256:637e98dcf185ba7f8e663e122ebf908c4702420477ae52a04f9908707456ba4d")
                   ;;Python-pydicom
                   (string-append
                    "-Dpython-pydicom_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/pydicom-2.4.4-py3-none-any.whl"))
                   (string-append
                    "-Dpython-pydicom_ARCHIVE_HASH:STRING="
                    "sha256:f9f8e19b78525be57aa6384484298833e4d06ac1d6226c79459131ddb0bd7c42")
                   ;;Python-six
                   (string-append
                    "-Dpython-six_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/six-1.16.0-py2.py3-none-any.whl"))
                   (string-append
                    "-Dpython-six_ARCHIVE_HASH:STRING="
                    "sha256:8abb2f1d86890a2dfb989f9a77cfcfd3e47c2a354b01111771326f8aa26e0254")
                   ;;Python-pillow
                   (string-append
                    "-Dpython-pillow_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/pillow-10.3.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"))
                   (string-append
                    "-Dpython-pillow_ARCHIVE_HASH:STRING="
                    "sha256:3102045a10945173d38336f6e71a8dc71bcaeed55c3123ad4af82c52807b9375")
                   ;;Python-retrying
                   (string-append
                    "-Dpython-retrying_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/retrying-1.3.4-py3-none-any.whl"))
                   (string-append
                    "-Dpython-retrying_ARCHIVE_HASH:STRING="
                    "sha256:8cc4d43cb8e1125e0ff3344e9de678fefd85db3b750b81b2240dc0183af37b35")
                   ;;Python-dicomweb-client
                   (string-append
                    "-Dpython-dicomweb-client_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/dicomweb_client-0.59.1-py3-none-any.whl"))
                   (string-append
                    "-Dpython-dicomweb-client_ARCHIVE_HASH:STRING="
                    "sha256:ad4af95e1bdeb3691841cf8b28894fc6d9ba7ac5b7892bff70a506eedbd20d79")
                   ;;Python-chardet
                   (string-append
                    "-Dpython-chardet_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/chardet-5.2.0-py3-none-any.whl"))
                   (string-append
                    "-Dpython-chardet_ARCHIVE_HASH:STRING="
                    "sha256:e1cf59446890a00105fe7b7912492ea04b6e6f06d4b742b2c788469e34c82970")
                   ;;Python-couchdb
                   (string-append
                    "-Dpython-couchdb_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/CouchDB-1.2-py2.py3-none-any.whl"))
                   (string-append
                    "-Dpython-couchdb_ARCHIVE_HASH:STRING="
                    "sha256:13a28a1159c49f8346732e8724b9a4d65cba54bec017c4a7eeb1499fe88151d1")
                   ;;Python-gitdb
                   (string-append
                    "-Dpython-gitdb_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/gitdb-4.0.11-py3-none-any.whl"))
                   (string-append
                    "-Dpython-gitdb_ARCHIVE_HASH:STRING="
                    "sha256:81a3407ddd2ee8df444cbacea00e2d038e40150acfa3001696fe0dcf1d3adfa4")
                   ;;Python-smmap
                   (string-append
                    "-Dpython-smmap_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/smmap-5.0.1-py3-none-any.whl"))
                   (string-append
                    "-Dpython-smmap_ARCHIVE_HASH:STRING="
                    "sha256:e6d8668fa5f93e706934a62d7b4db19c8d9eb8cf2adbb75ef1b675aa332b69da")
                   ;;Python-cryptography
                   (string-append
                    "-Dpython-cryptography_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/cryptography-42.0.7-cp39-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"))
                   (string-append
                    "-Dpython-cryptography_ARCHIVE_HASH:STRING="
                    "sha256:0d563795db98b4cd57742a78a288cdbdc9daedac29f2239793071fe114f13785")
                   ;;Python-PyJWT
                   (string-append
                    "-Dpython-PyJWT_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/PyJWT-2.8.0-py3-none-any.whl"))
                   (string-append
                    "-Dpython-PyJWT_ARCHIVE_HASH:STRING="
                    "sha256:59127c392cc44c2da5bb3192169a91f429924e17aff6534d70fdc02ab3e04320")
                   ;;Python-wrapt
                   (string-append
                    "-Dpython-wrapt_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/wrapt-1.16.0-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl"))
                   (string-append
                    "-Dpython-wrapt_ARCHIVE_HASH:STRING="
                    "sha256:f8212564d49c50eb4565e502814f694e240c55551a5f1bc841d4fcaabb0a9b8a")
                   ;;Python-Deprecated
                   (string-append
                    "-Dpython-Deprecated_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/Deprecated-1.2.14-py2.py3-none-any.whl"))
                   (string-append
                    "-Dpython-Deprecated_ARCHIVE_HASH:STRING="
                    "sha256:6fac8b097794a90302bdbb17b9b815e732d3c4720583ff1b198499d78470466c")
                   ;;Python-pycparser
                   (string-append
                    "-Dpython-pycparser_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/pycparser-2.22-py3-none-any.whl"))
                   (string-append
                    "-Dpython-pycparser_ARCHIVE_HASH:STRING="
                    "sha256:c3702b6d3dd8c7abc1afa565d7e63d53a1d0bd86cdc24edd75470f4de499cfcc")
                   ;;Python-cffi
                   (string-append
                    "-Dpython-cffi_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/cffi-1.16.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"))
                   (string-append
                    "-Dpython-cffi_ARCHIVE_HASH:STRING="
                    "sha256:8f8e709127c6c77446a8c0a8c8bf3c8ee706a06cd44b1e827c3e6a2ee6b8c098")
                   ;;Python-PyNaCl
                   (string-append
                    "-Dpython-PyNaCl_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/PyNaCl-1.5.0-cp36-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_24_x86_64.whl"))
                   (string-append
                    "-Dpython-PyNaCl_ARCHIVE_HASH:STRING="
                    "sha256:0c84947a22519e013607c9be43706dd42513f9e6ae5d39d3613ca1e142fba44d")
                   ;;Python-python-dateutil
                   (string-append
                    "-Dpython-python-dateutil_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/python_dateutil-2.9.0.post0-py2.py3-none-any.whl"))
                   (string-append
                    "-Dpython-python-dateutil_ARCHIVE_HASH:STRING="
                    "sha256:a8b2bc7bffae282281c8140a97d3aa9c14da0b136dfe83f850eea9a5f7470427")
                   ;;Python-typing_extensions
                   (string-append
                    "-Dpython-typing_extensions_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/typing_extensions-4.12.1-py3-none-any.whl"))
                   (string-append
                    "-Dpython-typing_extensions_ARCHIVE_HASH:STRING="
                    "sha256:6024b58b69089e5a89c347397254e35f1bf02a907728ec7fee9bf0fe837d203a")
                   ;;Python-PyGithub
                   (string-append
                    "-Dpython-PyGithub_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/PyGithub-2.3.0-py3-none-any.whl"))
                   (string-append
                    "-Dpython-PyGithub_ARCHIVE_HASH:STRING="
                    "sha256:65b499728be3ce7b0cd2cd760da3b32f0f4d7bc55e5e0677617f90f6564e793e")
                   ;;Python-packaging
                   (string-append
                    "-Dpython-packaging_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/packaging-24.0-py3-none-any.whl"))
                   (string-append
                    "-Dpython-packaging_ARCHIVE_HASH:STRING="
                    "sha256:2ddfb553fdf02fb784c234c7ba6ccc288296ceabec964ad2eae3777778130bc5")
                   ;;Python-pyparsing
                   (string-append
                    "-Dpython-pyparsing_ARCHIVE:FILEPATH="
                     (string-append (getcwd) "/source/wheelhouse/pyparsing-3.1.2-py3-none-any.whl"))
                   (string-append
                    "-Dpython-pyparsing_ARCHIVE_HASH:STRING="
                    "sha256:f9db75911801ed778fe61bb643079ff86601aca99fcae6345aa67292038fb742")
                   )))
    (home-page "https://slicer.org")
    (synopsis "3D Slicer")
    (description
     "Medical-image computing")
    (license slicer-license)))

slicer-desktop-5.8
