const gulp = require( "gulp" );
const sass = require( "gulp-sass" );
const cleanCSS = require( "gulp-clean-css" );

gulp.task( "sass", () => {
	return gulp.src( "./style/index.scss" )
		.pipe( sass() )
		.pipe( cleanCSS() )
		.pipe( gulp.dest( "./style" ) );
} );

gulp.task( "watch:sass", () => {
	gulp.watch( "./style/**/*.scss", ["sass"] );
} );