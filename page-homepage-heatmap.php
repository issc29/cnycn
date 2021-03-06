<?php
/*
 Template Name: Homepage-Heatmap
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

<style>
#gradient
{
font-weight:bold;
width: 200px;
height: 30px;
}

#radius
{
font-weight:bold;
width: 200px;
height: 30px;
}

</style>

<?php get_header(); ?>

			<h1 class="mobile-heading"><?php echo $post->title; ?></h1>

			<div id="content">

        <?php if (have_posts()) : while (have_posts()) : the_post(); ?>

          <?php the_content(); ?>

          <?php /* This used to be in the shortcode, but I moved it here
                   so I could add the Next button into the right column. */ ?>
          <div class="map-column map-column-left">
            <div id="map-canvas"></div>
			


          </div><div class="map-column map-column-right">
         <button id="gradient" onclick="changeGradient()">Change gradient</button></br>
<button id="radius" onclick="changeRadius()">Change radius</button> 

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
 
          <script type="text/javascript">
//            initialize_maps();
          </script>

        <?php endwhile; endif; ?>

      <br/>
   <br/>
   <br/>
   <br/>
   <br/>
   <br/>

      </div>


