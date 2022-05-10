'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "ff3bb1da125f610c0ff2f51b00ba771f",
"splash/img/light-background.png": "2e3e6d5197959563082e5fb30bc227d7",
"splash/img/dark-background.png": "2e3e6d5197959563082e5fb30bc227d7",
"splash/splash.js": "c6a271349a0cd249bdb6d3c4d12f5dcf",
"splash/style.css": "8327a119a599f3bd070470049ad2e7e5",
"index.html": "c0c6b09d60c1093db8eb03f8b87044a7",
"/": "c0c6b09d60c1093db8eb03f8b87044a7",
"main.dart.js": "bc9867330de9ac6682ed5dbea1875e30",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "2b2e6e4fb548be253e9b1fa1bd0ef456",
"assets/AssetManifest.json": "20abcbf0eb6f1212398299fd97a36d0e",
"assets/NOTICES": "7122de05e86d51643a40fffc0fa4f430",
"assets/FontManifest.json": "805123b2ae43c36a24a79dc42f3cc613",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/fonts/MaterialIcons-Regular.otf": "7e7a6cccddf6d7b20012a548461d5d81",
"assets/assets/locales/en_US.json": "b0ac94f057a7ddf01bdab890b97917b7",
"assets/assets/locales/french_FR.json": "2d9264279f99db02d3398417b4c74788",
"assets/assets/images/logo_transparent.png": "482c58274db1f7872eebf44d64f6d4c9",
"assets/assets/images/splash.gif": "6d49e0eb83fa982afe3e0dedfe5e1852",
"assets/assets/images/icon_gif.gif": "60b8eabda3c59075f00842374ef58856",
"assets/assets/images/nothing.png": "1d6678c3142ba367861fd1acfe526bee",
"assets/assets/images/logo_placeholder.png": "b0035cffc6987e0cff379925f56d6abe",
"assets/assets/images/invite.png": "066f5ce21a1177ab420585ab7d21e015",
"assets/assets/images/placeholder.jpg": "6553a6f588db697bce5d12aa137215b6",
"assets/assets/images/splash.png": "6d49e0eb83fa982afe3e0dedfe5e1852",
"assets/assets/images/ic_launcher.png": "b6f0d682bfd43178100d912dc98c04ce",
"assets/assets/images/wall.png": "6dfe81f27cea8cda0fa17ead58e8302d",
"assets/assets/images/watch_ads.png": "1f764c15c6346f86f743fb1a4492e445",
"assets/assets/images/splash_bg.png": "2e3e6d5197959563082e5fb30bc227d7",
"assets/assets/flr/login_duck.flr": "f64dd5ff380b1e632dfab5a49db72b18",
"assets/assets/flr/loader.riv": "4f2bf130719a761f6830974034399092",
"assets/assets/flr/teddytest.flr": "4921756575f143213512ba6db31ab656",
"assets/assets/lottie/spinner.json": "0e71b319dc094270058a141d15b851f7",
"assets/assets/fonts/Metropolis-Regular.ttf": "1bed04d51727dfccbac99dcef6cb7e2e",
"assets/assets/fonts/Metropolis-RegularItalic.ttf": "56371d2c665f8ff8da5e8192711a6abf",
"assets/assets/fonts/Metropolis-ExtraBold.ttf": "174c7fda3fdb4de0d4785975942d1382",
"assets/assets/fonts/Metropolis-SemiBoldItalic.ttf": "9fbf6610bfaa9c3fb3d4a81bbc592ce0",
"assets/assets/fonts/Metropolis-Bold.ttf": "1fee38d20ed958612a79f6877d9fdff7",
"assets/assets/fonts/JustBubble.ttf": "ad118fd848f5254b108b7e7bfab6b7b7",
"assets/assets/fonts/Metropolis-ExtraBoldItalic.ttf": "37d188894e9ce7556677c1b386e1a13a",
"assets/assets/fonts/Metropolis-SemiBold.ttf": "eba48789633b3549743b1faedef33140",
"assets/assets/fonts/Metropolis-MediumItalic.ttf": "aba01a90d380937566a81243ab7a1d37",
"assets/assets/fonts/Metropolis-BoldItalic.ttf": "99494c46ad4f66990c8a5c9daaa9d676",
"assets/assets/fonts/Metropolis-Medium.ttf": "6e1f782a0038d26f15614f5c0a669865",
"canvaskit/canvaskit.js": "c2b4e5f3d7a3d82aed024e7249a78487",
"canvaskit/profiling/canvaskit.js": "ae2949af4efc61d28a4a80fffa1db900",
"canvaskit/profiling/canvaskit.wasm": "95e736ab31147d1b2c7b25f11d4c32cd",
"canvaskit/canvaskit.wasm": "4b83d89d9fecbea8ca46f2f760c5a9ba"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
