# httpbin-zeit Changelog

## [1.0.10](https://github.com/ZeitOnline/httpbin/compare/1.0.9...1.0.10) (2026-11-05)


### Bug Fixes

* update to a maintained brotli library ([4457d59](https://github.com/ZeitOnline/httpbin/commit/4457d592d72d874cf253d1190374908ad8dc8587))
* update to a maintained brotli library ([10e3174](https://github.com/ZeitOnline/httpbin/commit/10e31745cf626d2ca06d18471c7455cdf1a7392d))

## [1.0.9](https://github.com/ZeitOnline/httpbin/compare/1.0.8...1.0.9) (2026-11-04)


### Bug Fixes

* switch to normal semver (and change the package name), to make release-please work ([8d952a7](https://github.com/ZeitOnline/httpbin/commit/8d952a7a15a73344cc54ccf3bb9566a82170fa83))

## 0.9.2+zon.8 (2025-10-10)

- Update to Python-3.14

## 0.9.2+zon.7 (2025-10-07)

- Update digest auth to current werkzeug API (changed in 2.3.0)

## 0.9.2+zon.6 (2024-03-18)

- Use static HTML body for /response-headers instead of json representation
  of the configured headers. (To provide some "data mass" for e.g. testing gzip)

## 0.9.2+zon.5 (2024-03-15)

- Allow overriding content-type header in /response-headers

## 0.9.2+zon.4 (2023-10-04)

- Update to current werkzeug API

## 0.9.2+zon.3 (2023-09-14)

- Allow PURGE method for /anything

## 0.9.2+zon.2 (2023-09-13)

- Allow all methods for /base64

## 0.9.2+zon.1 (2020-12-02)

- Add /head endpoint
