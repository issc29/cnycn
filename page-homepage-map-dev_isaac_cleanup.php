<?php
/*
 Template Name: Homepage-Map-Dev-isaac-cleanup
 *
 * This is your custom page template. You can create as many of these as you need.
 * Simply name is "page-whatever.php" and in add the "Template Name" title at the
 * top, the same way it is here.
 *
 * When you create your page, you can just select the template and viola, you have
 * a custom page template to call your very own. Your mother would be so proud.
 *
 * For more info: http://codex.wordpress.org/Page_Templates
*/
?>

<?php get_header(); ?>

			<h1 class="mobile-heading"><?php echo $post->title; ?></h1>

			<div id="content">

        <?php if (have_posts()) : while (have_posts()) : the_post(); ?>

          <?php the_content(); ?>

          <?php /* This used to be in the shortcode, but I moved it here
                   so I could add the Next button into the right column. */ ?>
          <div class="map-column map-column-left">
            <div id="map-canvas"></div>
			<div id="map-selector" class="controls  control-right"></div>
			<div id="legend" class="controls control-right control-bottom"></div>
          </div><div class="map-column map-column-right">
            <form action="#" id="addressSearchForm">
            	<div class="form-elements">
            	  <label class="label-address"><strong>Get Started</strong>
 <input id="pac-input" class="input-address input-text" type="text" placeholder="Enter your Address">
  <input id="submitbutton" class="submitbutton" value="Search" /></label>


              </div>
              <div class="form-results"></div>
              <input type="button" class="submit clear" value="New Search" style="display:none;" />
            </form>
            <div id="map-explanation"></div>

            <br/>

             <div class="next">
              <?php echo next_page_not_post("Next: %title",'expand'); ?>
              <?php echo next_page_not_post('&nbsp;','expand'); ?>
              <?php /* Options:
              - Link text
              - loop (bool)
              - WP query */ ?>
            </div>
          </div>

          </div>
 

        <?php endwhile; endif; ?>

      <br/>
   <br/>
   <br/>
   <br/>
   <br/>
   <br/>
<?php get_footer(); ?>
      </div>


