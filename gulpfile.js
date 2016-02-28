var gulp = require("gulp");
var watch = require("gulp-watch");
var elm = require("gulp-elm");
var sass = require("gulp-sass");
var autoprefixer = require("gulp-autoprefixer");
var plumber = require("gulp-plumber");

var paths = {
  scripts: {
    src: "elm/**/*.elm",
    dest: "js/",
  },
  styles: {
    src: "sass/**/*.scss",
    dest: "css/",
  },
  images: "images/**/*",
};

gulp.task("elm-init", elm.init);

gulp.task("elm", ["elm-init"], function() {
  return gulp.src(paths.scripts.src)
    .pipe(plumber())
    .pipe(elm())
    .pipe(gulp.dest(paths.scripts.dest));
});

gulp.task("sass", function () {
  return gulp.src(paths.styles.src)
    .pipe(plumber())
    .pipe(sass({
      outputStyle: "compressed",
      sourceComments: "map",
    }))
    .pipe(autoprefixer({
      browsers: ["last 2 versions"]
    }))
    .pipe(gulp.dest(paths.styles.dest))
});

gulp.task("watch", function() {
  gulp.watch(paths.scripts.src, ["elm"], { verbose: true });
  gulp.watch(paths.styles.src, ["sass"], { verbose: true });
});

gulp.task("build", ["elm", "sass"]);
gulp.task("dev", ["build", "watch"]);
gulp.task("default", ["build"]);
