# ViewControllerTransitions
UIKit: ViewControllers Animation Transitions

Transition Steps  
	a. Create an animator    
   b. conforms to UIViewControllerTransitioningDelegate    
      b-1. func animationController(forPresented:_, presenting:_, source:_) -> UIViewControllerAnimatedTransitioning? {  
		     return self }    
      b-2. func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {  
		     return self }  
   c. conformts to UIViewControllerAnimatedTransitioning  
      c-1. func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {  
		return duration }  
      c-2. func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {  
            // Get reference to our fromView, toView and the containerView  
            // Set up the transform will be used in the animation  
            // Make the toView off screen  
            // Add both fromView and toView to the containerView  
	    // Perform the animation  
	    // Complete transition
      }  
    d. assign destination ViewController's transitioningDelegate to animator
    e. note: if reverse, roles of toView and fromView will flip
  
  
1. Slide up transition: Default present modally segue   
2. Slide down transition  (background view will slide alone with)  
3. Slide right transition (background view will stay at same position)  
4. Pop transition
5. Rotataion transition  
6. Partial Slide down transition
